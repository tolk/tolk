class Translation < ActiveRecord::Base
  validates_presence_of :text

  belongs_to :phrase
  belongs_to :locale
end
