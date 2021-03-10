Tolk::Engine.routes.draw do
  resources :locales, only: [:index, :show, :create, :edit, :update]

  post "/dump_all" => "locales#dump_all", as: :dump_all_locales
  get "/stats" => "locales#stats"

  root to: 'locales#index'
end
