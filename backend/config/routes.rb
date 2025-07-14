Rails.application.routes.draw do
  post "auth/login", to: "auth#login"
  
  resources :rewards, only: [:index]
  resources :redemptions, only: [:index, :create]
  
  scope :user do
    post "/", to: "users#create"
    get "/", to: "users#show"
    patch "/", to: "users#update"
    get "balances", to: "users#balances"
  end
  
  namespace :admin do
    resources :users do
      member do
        get "balances"
        post "balances", to: "users#adjust_balances"
      end
    end
  end
  
  get "up" => "rails/health#show", as: :rails_health_check
end