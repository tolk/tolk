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

    validates_uniqueness_of :key

    scope :containing_text, lambda { |query|
      where("tolk_phrases.key LIKE ?", "%#{query}%")
    }
  end
end
