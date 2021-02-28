Tolk::Engine.routes.draw do
  resources :locales, only: [:index, :show, :update] do
    member do
      get :incomplete_translations
      get :completed_translations
    end
  end
  
  resource :search

  post "/dump_all" => "locales#dump_all", as: :dump_all_locales
  get "/stats" => "locales#stats"

  root to: 'locales#index'
end
