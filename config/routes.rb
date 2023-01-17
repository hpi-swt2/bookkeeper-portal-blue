Rails.application.routes.draw do

  resources :items
  get 'dashboard', to: 'dashboard#index'
  get 'search', to: 'search#index'
  get 'notifications', to: 'notifications#index'
  get 'notifications/:id', to: 'notifications#show'
  post 'notifications/:id/accept', to: 'notifications#accept'
  post 'notifications/:id/decline', to: 'notifications#decline'
  resources :notifications
  get 'profile', to: 'profile#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # https://github.com/heartcombo/devise/blob/main/README.md
  devise_for :users, controllers: { registrations: 'users', omniauth_callbacks: "users/omniauth_callbacks", sessions: 'sessions/sessions' }
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
  post 'deny_lend/:id', to: 'items#deny_lend', as: 'deny_lend'
  get 'generate_qrcode/:id', to: 'items#generate_qrcode', as: 'generate_qrcode'
  post 'start_lend/:id', to: 'items#start_lend', as: 'start_lend'

  resources :groups
  post 'groups/:id/promote/:user_id', to: 'groups#promote', as: 'group_promote'
  post 'groups/:id/demote/:user_id', to: 'groups#demote', as: 'group_demote'
  # Defines the root path route ("/")
  root "landing_page#index"
end
