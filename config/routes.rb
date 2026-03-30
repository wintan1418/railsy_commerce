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

  # Order Tracking
  get "track", to: "storefront/tracking#search", as: :track_search
  get "track/:tracking_number", to: "storefront/tracking#show", as: :tracking

  # Chat
  post "chat", to: "storefront/chat#create"
  get "chat/messages", to: "storefront/chat#messages"

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

  # Product Comparison
  get "compare", to: "storefront/compare#show", as: :compare

  # Customer Account
  namespace :account do
    root "dashboard#show"
    resources :orders, only: %i[index show] do
      resources :returns, only: %i[new create]
      resource :receipt, only: %i[show], controller: "receipts"
    end
    resources :returns, only: %i[show]
    resources :addresses
    resource :profile, only: %i[show update], controller: "profile"
    resource :wishlist, only: %i[show] do
      post :toggle, on: :member
    end
    resources :notifications, only: %i[index] do
      post :mark_read, on: :member
      post :mark_all_read, on: :collection
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
    resources :conversations, only: %i[index show] do
      post :reply, on: :member
    end
    resources :deliveries, only: %i[index create]
    resource :import, only: %i[new create], controller: "imports"
    resource :theme, only: %i[show update], controller: "theme"
    resource :settings, only: %i[show update], controller: "settings"
    resource :setup, only: %i[show update], controller: "setup"
  end

  # Vendor Dashboard
  namespace :vendor do
    root "dashboard#show"
    resources :products
    resources :orders, only: %i[index show update]
  end

  # Rider Dashboard
  namespace :rider do
    root "dashboard#show"
    resources :deliveries, only: %i[index show] do
      member do
        post :accept
        post :pick_up
        post :in_transit
        post :complete
      end
    end
  end

  # API
  namespace :api do
    namespace :v1 do
      resources :products, only: [ :index, :show ]
      resources :orders, only: [ :index, :show ]
      resource :cart, only: [ :show ], controller: "cart" do
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

  # PWA
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Hire a developer
  get "hire", to: "pages#hire"

  # Static pages (catch-all, must be last)
  get "/:slug", to: "pages#show", as: :page
end
