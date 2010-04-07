module Tolk
  class Locale < ActiveRecord::Base
    MAPPING = {
      'en' => 'English',
      'de' => 'German',
      'es' => 'Spanish',
      'da' => 'Dansk'
    }

    has_many :phrases, :through => :translations, :class_name => 'Tolk::Phrase'
    has_many :translations, :include => :phrase, :class_name => 'Tolk::Translation'

    cattr_accessor :locales_config_path
    self.locales_config_path = "#{Rails.root}/config/locales"

    cattr_accessor :primary_locale_name

    include Tolk::Sync

    validates_uniqueness_of :name
    validates_presence_of :name

    class << self
      def primary_locale(reload = false)
        @_primary_locale = nil if reload
        @_primary_locale ||= begin
          raise "Primary locale is not set. Please set Locale.primary_locale_name in your application's config file" unless self.primary_locale_name
          find_or_create_by_name(self.primary_locale_name)
        end
      end

      def primary_language_name
        primary_locale.language_name
      end

      def secondary_locales
        all - [primary_locale]
      end

      def dump_all(to = self.locales_config_path)
        secondary_locales.each do |locale|
          File.open("#{to}/#{locale.name}.yml", "w+") do |file|
            YAML.dump(locale.to_hash, file)
          end
        end
      end
    end

    def phrases_with_translation
      @_phrases_with_translation ||= translations.collect do |translation|
        translation.phrase.translation = translation
        translation.phrase
      end.sort_by(&:key)
    end

    def phrases_without_translation
      @_phrases_without_translation ||= (Tolk::Phrase.all - phrases).sort_by(&:key)
    end

    def to_hash
      { name => translations.each_with_object({}) do |translation, locale|
        if translation.phrase.key.include?(".")
          locale.deep_merge!(unsquish(translation.phrase.key, translation.text))
        else
          locale[translation.phrase.key] = translation.text
        end
      end }
    end

    def to_param
      name.parameterize
    end

    def primary?
      name == self.class.primary_locale_name
    end

    def language_name
      MAPPING[self.name.downcase] || self.name
    end

    private
      def unsquish(string, value)
        if string.is_a?(String)
          unsquish(string.split("."), value)
        elsif string.size == 1
          { string.first => value }
        else
          key  = string[0]
          rest = string[1..-1]
          { key => unsquish(rest, value) }
        end
      end
  end
end
