Rails.application.routes.draw do
  # Authentication
  resource :session, only: %i[new create destroy]
  resource :registration, only: %i[new create]
  resources :passwords, param: :token

  # OAuth
  get "auth/:provider/callback", to: "omniauth_callbacks#google_oauth2", as: :omniauth_callback
  get "auth/failure", to: "omniauth_callbacks#failure"

  # Storefront
  root "pages#home"

  resources :products, only: %i[index show], controller: "storefront/products" do
    resources :reviews, only: %i[create], controller: "storefront/reviews"
  end
  resources :categories, only: %i[show], controller: "storefront/categories", param: :slug

  # Cart
  resource :cart, only: %i[show]
  resources :cart_items, only: %i[create update destroy]

  # Checkout
  resource :checkout, only: %i[show update], controller: "checkouts" do
    get :confirm
  end

  # Customer Account
  namespace :account do
    root "orders#index"
    resources :orders, only: %i[index show] do
      resources :returns, only: %i[new create]
    end
    resources :returns, only: %i[show]
    resources :addresses
    resource :profile, only: %i[show update], controller: "profile"
    resource :wishlist, only: %i[show] do
      post :toggle, on: :member
    end
  end

  # Admin
  namespace :admin do
    root "dashboard#show"
    resources :products
    resources :orders, only: %i[index show update]
    resources :customers, only: %i[index show]
    resources :categories
    resources :inventory, only: %i[index update]
    resources :shipping_methods
    resources :reviews, only: %i[index update destroy]
    resources :discounts
    resources :promotions
    resources :tax_rates
    resources :returns, only: %i[index show update]
    resources :pages
    resource :settings, only: %i[show update], controller: "settings"
  end

  # API
  namespace :api do
    namespace :v1 do
      resources :products, only: [:index, :show]
      resources :orders, only: [:index, :show]
      resource :cart, only: [:show], controller: "cart" do
        post :add_item
        patch :update_item
        delete :remove_item
      end
    end
  end

  # Webhooks
  namespace :webhooks do
    resource :stripe, only: %i[create], controller: "stripe"
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Static pages (catch-all, must be last)
  get "/:slug", to: "pages#show", as: :page
end
