module Tolk
  module Import
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods

      def import_secondary_locales
        locales = Dir.entries(self.locales_config_path)
        locales = locales.reject {|l| ['.', '..'].include?(l) || !l.ends_with?('.yml') }.map {|x| x.split('.').first } - [Tolk::Locale.primary_locale.name]

        locales.each {|l| import_locale(l) }
      end

      def import_locale(locale_name)
        locale = Tolk::Locale.find_or_create_by_name(locale_name.downcase)
        data = locale.read_locale_file

        phrases = Tolk::Phrase.all
        count = 0

        data.each do |key, value|
          phrase = phrases.detect {|p| p.key == key}

          unless phrase
            phrase = Tolk::Phrase.create!(:key => key)
            Tolk::Locale.primary_locale.translations.create!(:phrase => phrase, :primary => true, :text => value)
          end

          translation = locale.translations.build(:text => value, :phrase => phrase)
          if translation.save
            count = count + 1
          else
            puts "[ERROR] Failed to import '#{key}' from #{locale_name}.yml - Errors : #{translation.errors.full_messages.inspect}"
          end
        end

        puts "[INFO] Imported #{count} keys from #{locale_name}.yml"
      end

    end

    def read_locale_file
      locale_file = "#{self.locales_config_path}/#{self.name}.yml"
      raise "Locale file #{locale_file} does not exists" unless File.exists?(locale_file)

      self.class.flat_hash(YAML::load(IO.read(locale_file))[self.name])
    end

  end
end
