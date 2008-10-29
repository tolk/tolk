class Translation < ActiveRecord::Base
  belongs_to :phrase
  belongs_to :locale
end
