module Tolk
  module Sync
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def sync!
        translations = read_primary_locale_file
        sync_phrases(translations)
      end

      def read_primary_locale_file
        primary_file = "#{self.locales_config_path}/#{self.primary_locale_name}.yml"
        raise "Primary locale file #{primary_file} does not exists" unless File.exists?(primary_file)

        flat_hash(YAML::load(IO.read(primary_file))[self.primary_locale_name])
      end

      def flat_hash(data, prefix = '', result = {})
        data.each do |key, value|
          current_prefix = prefix.present? ? "#{prefix}.#{key}" : key

          if value.is_a?(Hash)
            flat_hash(value, current_prefix, result)
          else
            result[current_prefix] = value
          end
        end

        result
      end

      private

      def sync_phrases(translations)
        primary_locale = self.primary_locale
        secondary_locales = self.secondary_locales

        # Handle deleted phrases
        I18n.available_locales # force load
        possible_keys = (flat_hash(I18n.backend.send(:translations)[primary_locale.name.to_sym]).keys + translations.keys).uniq
        possible_keys.present? ? Tolk::Phrase.destroy_all(["tolk_phrases.key NOT IN (?)", possible_keys]) : Tolk::Phrase.destroy_all

        phrases = Tolk::Phrase.all

        translations.each do |key, value|
          # Create phrase and primary translation if missing
          existing_phrase = phrases.detect {|p| p.key == key} || Phrase.create!(:key => key)
          translation = existing_phrase.translations.primary || primary_locale.translations.build(:phrase_id => existing_phrase.id)

          # Update primary translation if it's been changed
          if value.present? && translation.text != value

            unless translation.new_record?
              # Set the primary updated flag if the translation is not new
              secondary_locales.each do |locale|
                if existing_translation = existing_phrase.translations.detect {|t| t.locale_id == locale.id }
                  existing_translation.force_set_primary_update = true
                  existing_translation.save!
                end
              end
            end

            translation.text = value 
            translation.save!
          end
        end
      end

    end

  end
end
