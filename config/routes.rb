ActionController::Routing::Routes.draw do |map|
  map.resources :applications, :member => { :dump => :post } do |applications|
    applications.resources :locales, :has_many => :translations
    applications.resources :phrases, :has_many => :translations
  end
  
  map.resources :translations
end
