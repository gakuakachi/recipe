Rails.application.routes.draw do
  resources :users, only: [:create]
  resources :sessions, only: [:create]
  resources :recipes, only: [:index, :create, :update, :destroy] do
    resources :rates, only: [:create, :update, :destroy]
  end
end
