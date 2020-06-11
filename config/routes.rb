Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  get '/error', to: 'pages#errorpage', as: 'page_error'

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
    resources :orders, only: [ :index, :create ]
  end

  resources :orders, only: [:show, :create] do
    resources :payments
  end
end


