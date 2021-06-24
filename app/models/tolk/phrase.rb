module Tolk
  class Phrase < ActiveRecord::Base
    self.table_name = "tolk_phrases"

    paginates_per 20

    attr_accessor :translation

    has_many :translations, class_name: 'Tolk::Translation', dependent: :destroy do
      def primary
        to_a.detect {|t| t.locale_id == Tolk::Locale.primary_locale.id}
      end

      def for(locale)
        to_a.detect {|t| t.locale_id == locale.id}
      end
    end

    validates :key, uniqueness: true

    scope :with_translation, ->(){
      where('tolk_translations.primary_updated' => false)
    }

    scope :with_updated_translation, ->(){
      where('tolk_translations.primary_updated' => true)
    }

    scope :containing_text, ->(query){
      where("tolk_phrases.key LIKE ?", "%#{query}%")
    }

    scope :search_translations, ->(search){
      left_joins(:translations).where("tolk_translations.text LIKE ?", "%#{search}%")
    }

  end
end
