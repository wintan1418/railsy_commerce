Rails.application.routes.draw do
  # Authentication
  resource :session, only: %i[new create destroy]
  resource :registration, only: %i[new create]
  resources :passwords, param: :token

  root "pages#home"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
