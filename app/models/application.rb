class Application < ActiveRecord::Base
  has_many :locales
  has_many :phrases
  
  def to_hash
    locales.each_with_object({}) do |locale, application|
      application[locale.name] = locale.to_hash
    end
  end
  
  def dump
    File.open(location + "/locales.yml", "w+") { |f| YAML.dump(to_hash, f) }
  end
end
