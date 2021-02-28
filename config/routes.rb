Tolk::Engine.routes.draw do
  root :to => 'locales#index'

  post "/dump_all" => "locales#dump_all", :as => :dump_all_locales
  get "/stats" => "locales#stats"

  resources :locales, only: [:index, :show, :update] do
    member do
      get :incomplete_translations
      get :completed_translations
    end
  end
  resource :search
end
