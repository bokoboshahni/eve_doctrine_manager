# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :user, path: '', controllers: { omniauth_callbacks: 'sso' }
  devise_scope :user do
    delete 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  get '/api', to: 'api#index'

  resources :doctrines

  resources :fittings

  resources :users

  root to: 'home#index'
end
