Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :buildings do
    resources :apartments, only: [ :index, :new, :create]
  end
  resources :apartments, only: [:show, :edit, :update, :destroy]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
