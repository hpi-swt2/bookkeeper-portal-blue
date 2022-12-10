Rails.application.routes.draw do
  resources :items
  get 'dashboard', to: 'dashboard#index'
  get 'search', to: 'search#index'
  get 'notifications', to: 'notifications#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # https://github.com/heartcombo/devise/blob/main/README.md
  devise_for :users, controllers: { registrations: 'users' }
  devise_scope :user do
    get 'profile', to: 'users#profile'
  end

  resources :users
  post 'request_return/:id', to: 'items#request_return', as: 'request_return'
  post 'accept_return/:id', to: 'items#accept_return', as: 'accept_return'
  post 'deny_return/:id', to: 'items#deny_return', as: 'deny_return'  
  post 'request_lend/:id', to: 'items#request_lend', as: 'request_lend'
  # Defines the root path route ("/")
  root "landing_page#index"
end


