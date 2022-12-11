Rails.application.routes.draw do
  resources :items
  get 'dashboard', to: 'dashboard#index'
  get 'search', to: 'search#index'
  get 'notifications', to: 'notifications#index'
  get 'notifications/:id', to: 'notifications#show'
  post 'notifications/:id/accept', to: 'notifications#accept'
  post 'notifications/:id/decline', to: 'notifications#decline'
  resources :notifications
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # https://github.com/heartcombo/devise/blob/main/README.md
  devise_for :users, controllers: { registrations: 'users' }
  devise_scope :user do
    get 'profile', to: 'users#profile'
  end

  resources :users
  # Defines the root path route ("/")
  root "landing_page#index"
end
