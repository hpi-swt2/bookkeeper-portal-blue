Rails.application.routes.draw do
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
  # Defines the root path route ("/")
  root "landing_page#index"
end
