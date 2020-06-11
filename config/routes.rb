Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  get '/error', to: 'pages#errorpage', as: 'page_error'

  resources :users, only: [] do
    resources :apartments, only: [ :index ]
    resources :schedules, only: [ :index ]
  end

  resources :buildings do
    collection { post :import }
    get :export, defaults: { format: 'xslx' }
    resources :apartments, only: [ :new, :create, :index ] do
    end
    resources :rooms
  end
  resources :apartments, only: [ :show, :edit, :update, :destroy ] do
    resources :payments, only: [ :index, :new, :create ]
  end
  resources :payments, only: [ :show, :edit, :update, :destroy ]
  resources :rooms, only: [ :show, :edit, :update, :destroy ] do
    resources :schedules, only: [ :index, :new, :create ]
  end
  resources :schedules, only: [ :show, :edit, :update, :destroy ]
end


