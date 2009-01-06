ActionController::Routing::Routes.draw do |map|
  map.resources :locales, :has_many => :translations
  map.resources :phrases, :has_many => :translations
  map.resources :translations
  
  map.root :locales
end
