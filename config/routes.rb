Tolk::Engine.routes.draw do
  root :to => 'locales#index'
  resources :locales do
    member do
      get :all
      get :updated
    end
    get :dump_all, :on => :collection
  end
  resource :search
end
