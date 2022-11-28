# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: [:create]
  resources :sessions, only: [:create]
  resources :recipes, only: %i[index show create update destroy] do
    resources :rates, only: %i[create update destroy]
  end
end
