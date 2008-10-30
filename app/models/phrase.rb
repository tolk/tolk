class Phrase < ActiveRecord::Base
  belongs_to :application
  has_many :translations
  
  attr_accessor :translation
end
