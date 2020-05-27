# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/health', to: 'health#health'
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
  put '/photos/:id', to: 'photos#update'
  resources :stores do
    resources :products
  end
  resources :users, only: %i[show create update] do
    get :avatar, on: :member
  end
end
