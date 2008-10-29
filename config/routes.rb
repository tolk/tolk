ActionController::Routing::Routes.draw do |map|
  map.resources :applications do |applications|
    applications.resources :locales, :has_many => :translations
    applications.resources :phrases, :has_many => :translations
  end
end
