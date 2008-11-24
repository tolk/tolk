class Locale < ActiveRecord::Base
  has_many :phrases, :through => :translations
  has_many :translations, :include => :phrase

  LOCALES_CONFIG_PATH = "#{Rails.root}/config/locales"

  class << self
    def dump_all(to = LOCALES_CONFIG_PATH)
      all.each do |locale|
        File.open("#{to}/#{locale.name}.yml", "w+") do |file|
          YAML.dump(locale.to_hash, file)
        end
      end
    end
  end


  def phrases_with_translation
    translations.collect do |translation|
      translation.phrase.translation = translation
      translation.phrase
    end.sort_by(&:key)
  end

  def phrases_without_translation
    (Phrase.all - phrases).sort_by(&:key)
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