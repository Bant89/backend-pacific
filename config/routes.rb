# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # Health Endpoint
  get '/health', to: 'health#health'

  # Auth & Password endpoints
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
  post 'password/forgot', to: 'password#forgot'
  post 'password/reset', to: 'password#reset'
  put 'password/update', to: 'password#update'

  # Image handling endpoints
  put '/photos/user/:id', to: 'photos#update_user'
  put '/photos/store/:id', to: 'photos#update_store'
  put '/photos/product/:id', to: 'photos#update_product'

  resources :stores do
    resources :products
  end
  resources :users, only: %i[show create update] do
    get :avatar, on: :member
  end
end
