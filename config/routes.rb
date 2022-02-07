Rails.application.routes.draw do
  root to: 'images#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :create]
  
  resources :images
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
