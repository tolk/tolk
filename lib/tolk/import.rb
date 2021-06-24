module Tolk
  module Import

    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def import_secondary_locales
        locales = Dir.entries(self.locales_config_path).reject{|l| 
          ['.', '..'].include?(l) || 
            !l.ends_with?('.yml') || 
            l.match(/(.*\.){2,}/) # reject files of type xxx.en.yml
        }.map{|x| x.split('.').first }

        (locales - [Tolk::Locale.primary_locale.name]).each do |l| 
          import_locale(l)
        end
      end

      def import_locale(locale_name)
        locale = Tolk::Locale.where(name: locale_name).first_or_create

        data = locale.read_locale_file

        if !data
          return
        end

        phrases_by_key = Tolk::Phrase.all.index_by(&:key)

        translated_phrase_ids = Set.new(locale.translations.pluck(:phrase_id))

        count = 0

        data.each do |key, value|
          phrase = phrases_by_key[key]

          if !phrase
            puts "[ERROR] Key '#{key}' was found in '#{locale_name}.yml' but #{Tolk::Locale.primary_language_name} translation is missing"
            next
          end

          if translated_phrase_ids.include?(phrase.id)
            next
          end

          translation = locale.translations.new(text: value, phrase: phrase)

          if translation.save
            count = count + 1
          elsif translation.errors[:variables].present?
            puts "[WARN] Key '#{key}' from '#{locale_name}.yml' could not be saved: #{translation.errors[:variables].first}"
          end
        end

        puts "[INFO] Imported #{count} keys from #{locale_name}.yml"
      end
    end

    def read_locale_file
      locale_file = "#{self.locales_config_path}/#{self.name}.yml"

      if !File.exist?(locale_file)
        raise "Locale file #{locale_file} does not exists"
      end

      puts "[INFO] Reading #{locale_file} for locale #{self.name}"

      begin
        self.class.flat_hash(Tolk::YAML.load_file(locale_file)[self.name])
      rescue
        puts "[ERROR] File #{locale_file} expected to declare #{self.name} locale, but it does not. Skipping this file."
        nil
      end
    end

  end
end
