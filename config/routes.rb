Rails.application.routes.draw do
  resources :items
  get 'dashboard', to: 'dashboard#index'
  get 'search', to: 'search#index'
  get 'notifications', to: 'notifications#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # https://github.com/heartcombo/devise/blob/main/README.md
  devise_for :users, controllers: { registrations: 'users', omniauth_callbacks: "users/omniauth_callbacks" }
  devise_scope :user do
    get 'profile', to: 'users#profile'
  end

  resources :users
  post 'add_to_waitlist/:id', to: 'items#add_to_waitlist', as: 'add_to_waitlist'
  post 'leave_waitlist/:id', to: 'items#leave_waitlist', as: 'leave_waitlist'
  post 'request_return/:id', to: 'items#request_return', as: 'request_return'
  post 'accept_return/:id', to: 'items#accept_return', as: 'accept_return'
  post 'deny_return/:id', to: 'items#deny_return', as: 'deny_return'
  post 'request_lend/:id', to: 'items#request_lend', as: 'request_lend'
  post 'accept_lend/:id', to: 'items#accept_lend', as: 'accept_lend'

  resources :groups
  # Defines the root path route ("/")
  root "landing_page#index"
end
