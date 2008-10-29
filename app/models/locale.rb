class Locale < ActiveRecord::Base
  has_many :translations, :include => :phrase
  
  def to_hash
    translations.each_with_object({}) do |translation, locale|
      if translation.phrase.key.include?(".")
        locale.deep_merge!(unsquish(translation.phrase.key, translation.text))
      else
        locale[translation.phrase.key] = translation.text
      end
    end
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