ActionController::Routing::Routes.draw do |map|
  map.with_options(:path_prefix => '/tolk') do |tolk|
    tolk.resources :locales, :has_many => :translations
    tolk.resources :phrases, :has_many => :translations
    tolk.resources :translations
  end
end
