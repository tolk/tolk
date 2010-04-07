module Tolk
  class Translation < ActiveRecord::Base
    validates_presence_of :text
    validates_uniqueness_of :phrase_id, :scope => :locale_id

    belongs_to :phrase, :class_name => 'Tolk::Phrase'
    belongs_to :locale, :class_name => 'Tolk::Locale'
  end
end
