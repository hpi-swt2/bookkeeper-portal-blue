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
  post 'stop_lending/:id', to: 'items#stop_lending', as: 'stop_lending'
  # Defines the root path route ("/")
  root "landing_page#index"
end


