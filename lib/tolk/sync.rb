module Tolk
  module Sync
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def sync!
        sync_phrases(load_translations)
      end

      def load_translations
        if Tolk.config.exclude_gems_token
          # bypass default init_translations
          I18n.backend.reload! if I18n.backend.initialized?
          I18n.backend.instance_variable_set(:@initialized, true)
          translations_files = Dir[Rails.root.join('config', 'locales', "*.{rb,yml}")]

          if Tolk.config.block_xxx_en_yml_locale_files
            locale_block_filter = Proc.new {
              |l| ['.', '..'].include?(l) ||
                !l.ends_with?('.yml') ||
                l.split("/").last.match(/(.*\.){2,}/) # reject files of type xxx.en.yml
            }
            translations_files =  translations_files.reject(&locale_block_filter)
          end

          I18n.backend.load_translations(translations_files)
        else
          I18n.backend.send :init_translations unless I18n.backend.initialized? # force load
        end
        translations = flat_hash(I18n.backend.send(:translations)[primary_locale.name.to_sym])
        filtered = filter_out_i18n_keys(translations.merge(read_primary_locale_file))
        filter_out_ignored_keys(filtered)
      end

      def read_primary_locale_file
        primary_file = "#{self.locales_config_path}/#{self.primary_locale_name}.yml"
        if File.exist?(primary_file)
          flat_hash(Tolk::YAML.load_file(primary_file)[self.primary_locale_name])
        else
          {}
        end
      end

      def flat_hash(data, prefix = '', result = {})
        data.each do |key, value|
          current_prefix = prefix.present? ? "#{prefix}.#{key}" : key

          if !value.is_a?(Hash) || Tolk::Locale.pluralization_data?(value)
            result[current_prefix] = value.respond_to?(:stringify_keys) ? value.stringify_keys : value
          else
            flat_hash(value, current_prefix, result)
          end
        end

        result.stringify_keys
      end

      private

      def sync_phrases(translations)
        primary_locale = self.primary_locale

        # Handle deleted phrases
        Tolk::Phrase.where.not(:key => translations.keys).destroy_all

        phrases_by_key = Tolk::Phrase.all.index_by(&:key)
        primary_translation_by_phrase_id = primary_locale.translations.index_by(&:phrase_id)

        translations.each do |key, value|
          next if value.is_a?(Proc)
          # Create phrase and primary translation if missing
          phrase = phrases_by_key[key] || Tolk::Phrase.create!(:key => key)
          translation = primary_translation_by_phrase_id[phrase.id]
          translation ||= primary_locale.translations.build(:phrase => phrase)
          translation.text = value

          if translation.changed? && !translation.new_record?
            # Set the primary updated flag if the primary translation has changed and it is not a new record.
            phrase.translations.where.not(:locale_id => primary_locale.id).update_all({ :primary_updated => true })
          end

          translation.primary = true
          translation.save! if translation.changed?
        end
      end

      def filter_out_i18n_keys(flat_hash)
        flat_hash.reject { |key, value| key.starts_with? "i18n" }
      end

      def filter_out_ignored_keys(flat_hash)
        ignored = Tolk.config.ignore_keys

        return flat_hash unless ignored.any?

        ignored_escaped = ignored.map { |key| Regexp.escape(key) }

        regexp = Regexp.new(/\A#{ignored_escaped.join('|')}/)

        flat_hash.reject { |key, _| regexp.match?(key) }
      end
    end
  end
end
