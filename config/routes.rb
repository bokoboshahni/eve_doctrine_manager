# frozen_string_literal: true

Rails.application.routes.draw do
  get '/api', to: 'api#index'

  resources :doctrines

  resources :fittings

  resources :users

  root to: 'home#index'
end
