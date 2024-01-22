Rails.application.routes.draw do
namespace :api do
  namespace :v1 do
    resources :items, path: '#/items', only: [:index, :show, :create, :update, :destroy]
    resources :users, param: :username, path: '', only: [:index, :show, :create, :update, :destroy] do
      resources :reservations, only: [:index, :show, :create, :update, :destroy] do
        resources :items, only: [:index, :show]
      end
    end
    
    get 'reservations/index_all', to: 'reservations#index_all'
  end
end
 # devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "api/v1/items#index"
  

  # config/routes.rb

devise_for :users, skip: [:sessions, :registrations, :passwords], controllers: {
  sessions: 'api/v1/users/sessions',
  registrations: 'api/v1/users/registrations',
  passwords: 'api/v1/users/passwords'
}, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout', registration: 'signup' }

# Manually define the routes for the skipped controllers
as :user do
  post 'auth/login', to: 'api/v1/users/sessions#create', as: :user_session
  delete 'auth/logout', to: 'api/v1/users/sessions#destroy', as: :destroy_user_session
  post 'auth/signup', to: 'api/v1/users/registrations#create', as: :user_registration
  put 'auth/password/reset', to: 'api/v1/users/passwords#update', as: :update_user_password
  post 'auth/password/forgot', to: 'api/v1/users/passwords#create', as: :forgot_user_password
end


end
