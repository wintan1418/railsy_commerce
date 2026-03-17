Rails.application.routes.draw do
  # Authentication
  resource :session, only: %i[new create destroy]
  resource :registration, only: %i[new create]
  resources :passwords, param: :token

  # Storefront
  root "pages#home"

  resources :products, only: %i[index show], controller: "storefront/products"
  resources :categories, only: %i[show], controller: "storefront/categories", param: :slug

  # Cart
  resource :cart, only: %i[show]
  resources :cart_items, only: %i[create update destroy]

  # Admin
  namespace :admin do
    root "dashboard#show"
    resources :products
    resources :orders, only: %i[index show update]
    resources :categories
  end

  # Webhooks
  namespace :webhooks do
    resource :stripe, only: %i[create], controller: "stripe"
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
