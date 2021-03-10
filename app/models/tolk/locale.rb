require 'tolk/config'
require 'tolk/pagination'

module Tolk
  class Locale < ActiveRecord::Base
    include Tolk::Pagination::Methods
    include Tolk::Sync
    include Tolk::Import

    self.table_name = "tolk_locales"

    if defined?(ProtectedAttributes)
      attr_accessible :name
    end

    def self._dump_path
      # Necessary to acces rails.root at runtime !
      @dump_path ||= Tolk.config.dump_path.is_a?(Proc) ? instance_eval(&Tolk.config.dump_path) : Tolk.config.dump_path
    end

    def to_param
      name.parameterize
    end

    cattr_accessor :locales_config_path
    self.locales_config_path = self._dump_path

    cattr_accessor :primary_locale_name
    self.primary_locale_name = Tolk.config.primary_locale_name || I18n.default_locale.to_s

    has_many :translations, class_name: 'Tolk::Translation', dependent: :destroy
    has_many :phrases, through: :translations, class_name: 'Tolk::Phrase'

    accepts_nested_attributes_for :translations, reject_if: proc { |attributes| attributes['text'].blank? }

    validates :name, presence: true, uniqueness: {case_sensitive: false}

    PLURALIZATION_KEYS = ['none', 'zero', 'one', 'two', 'few', 'many', 'other']

    # http://cldr.unicode.org/index/cldr-spec/plural-rules - TODO: usage of 'none' isn't standard-conform
  
    def self.primary_locale(reload = false)
      if reload
        @_primary_locale = nil
      end

      @_primary_locale ||= begin
        raise "Primary locale is not set. Please set Locale.primary_locale_name in your application's config file" unless self.primary_locale_name
        where(name: self.primary_locale_name).first_or_create
      end
    end

    def self.primary_language_name
      primary_locale.language_name
    end

    def self.secondary_locales
      all - [primary_locale]
    end

    def self.dump_all(*args)
      secondary_locales.each { |locale| locale.dump(*args) }
    end

    def self.dump_yaml(name, *args)
      where(name: name).first.dump(*args)
    end

    def self.pluralization_data?(data)
      keys = data.keys.map(&:to_s)
      keys.all? {|k| PLURALIZATION_KEYS.include?(k) }
    end

    def self.rename(old_name, new_name)
      if old_name.blank? || new_name.blank?
        "You need to provide both names, aborting."
      else
        if locale = where(name: old_name).first
          locale.name = new_name

          locale.save

          return "Locale ' #{old_name}' was renamed '#{new_name}'"
        else
          return "Locale with name '#{old_name}' not found."
        end
      end
    end

    def to_hash
      result = translations.joins(:phrase).order("tolk_phrases.key ASC").pluck("tolk_phrases.key, text")

      data = result.each_with_object(Hash.new(0)) do |translation, locale|
        if translation[0].include?(".")
          locale.deep_merge!(unsquish(translation[0], translation[1]))
        else
          locale[translation[0]] = translation[1]
        end
      end

      return { name => data }
    end

    def dump(to = self.locales_config_path, exporter = Tolk::Export)
      exporter.dump(name: name, data: to_hash, destination: to)
    end

    def has_updated_translations?
      translations.where('tolk_translations.primary_updated' => true).count > 0
    end

    def count_phrases_without_translation
      Tolk::Phrase.count - self.translations.pluck(:phrase_id).uniq.count
    end

    def count_phrases_with_updated_translation
      find_phrases_with_translations('tolk_translations.primary_updated' => true).count
    end

    def phrases_without_translation
      phrases = Tolk::Phrase.all.includes(:translations).order('tolk_phrases.key ASC')

      phrases = phrases.where('tolk_phrases.id NOT IN (?)', self.translations.pluck(:phrase_id).uniq)

      return phrases
    end

    def primary?
      name == self.class.primary_locale_name
    end

    def language_name
      Tolk.config.mapping[self.name] || self.name
    end

    private

    def find_phrases_with_translations(conditions = {})
      result = Tolk::Phrase
        .includes(:translations).references(:translations)
        .where({'tolk_translations.locale_id' => self.id}.merge(conditions))
        .order('tolk_phrases.key ASC')

      result.each do |phrase|
        phrase.translation = phrase.translations.for(self)
      end

      result
    end

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
