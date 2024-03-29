Rails.application.routes.draw do

  resources :items
  get 'items/:id/image', to: 'items#image', as: 'item_image'
  get 'dashboard', to: 'dashboard#index'
  get 'search', to: 'search#index'
  get 'notifications', to: 'notifications#index'
  get 'notifications/:id', to: 'notifications#show'
  post 'notifications/:id/accept_lend', to: 'notifications#accept_lend', as: 'notification_accept_lend'
  post 'notifications/:id/decline_lend', to: 'notifications#decline_lend', as: 'notification_deny_lend'
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
  get 'add_to_favorites/:id', to: 'items#add_to_favorites', as: 'add_to_favorites'
  get 'leave_favorites/:id', to: 'items#leave_favorites', as: 'leave_favorites'
  post 'request_return/:id', to: 'items#request_return', as: 'request_return'
  post 'request_lend/:id', to: 'items#request_lend', as: 'request_lend'
  get 'generate_qrcode/:id', to: 'items#generate_qrcode', as: 'generate_qrcode'
  post 'start_lend/:id', to: 'items#start_lend', as: 'start_lend'
  post 'accept_return/:id', to: 'notifications#accept_return', as: 'accept_return'
  post 'deny_return/:id', to: 'notifications#decline_return', as: 'deny_return'

  resources :groups
  post 'groups/:id/add_member', to: 'groups#add_member', as: 'add_member'
  post 'groups/:id/promote/:user_id', to: 'groups#promote', as: 'group_promote'
  post 'groups/:id/demote/:user_id', to: 'groups#demote', as: 'group_demote'
  post 'groups/:id/remove/:user_id', to: 'groups#remove', as: 'group_remove'
  delete 'groups/:id/leave', to: 'groups#leave', as: 'group_leave'
  # Defines the root path route ("/")
  root "landing_page#index"
end
