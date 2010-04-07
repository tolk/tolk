class Phrase < ActiveRecord::Base
  has_many :translations, :dependent => :destroy do
    def primary
      to_a.detect {|t| t.locale_id == Locale.primary_locale.id}
    end

    def secondary(locale)
      to_a.detect {|t| t.locale_id == locale.id}
    end
  end

  attr_accessor :translation
end
