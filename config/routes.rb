Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :users, only: [] do
    resources :apartments, only: [ :index ]
  end

  resources :buildings do
    collection { post :import }
    get :export, defaults: { format: 'xslx' }
    resources :apartments, only: [ :new, :create, :index ] do
    end
  end
  resources :apartments, only: [ :show, :edit, :update, :destroy ] do
    resources :payments, only: [ :index, :new, :create ]
  end
  resources :payments, only: [ :show, :edit, :update, :destroy ]
end


