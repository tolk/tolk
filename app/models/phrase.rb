class Phrase < ActiveRecord::Base
  has_many :translations
  
  attr_accessor :translation
end
