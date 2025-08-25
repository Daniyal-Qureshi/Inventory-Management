Rails.application.routes.draw do
  root to: 'products#index'
  get 'sign_in', to: 'sessions#new', as: :sign_in
  post 'sign_in', to: 'sessions#create'
  delete 'sign_out', to: 'sessions#destroy', as: :sign_out

  resources :employees, only: :index
  resources :orders, only: %i[index show] do
    resource :fulfill, only: [:create]
    resource :return, only: %i[create show]
    resource :address, only: [:update]
  end

  resources :products do
    resource :receive, only: [:create]
    resource :restock, only: [:create]
  end
  resources :customer_service, only: [:index]
end
