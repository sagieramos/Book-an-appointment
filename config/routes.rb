Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
  namespace :api do
    namespace :v1 do
      resources :pages, path: 'p' do
        collection do
          get :reservations
          get :items
          get :search
          get 'items/:id', to: 'pages#show_item', as: 'show_item'
          delete 'items/:id', to: 'pages#destroy_item', as: 'destroy_item'
        end
      end
  
      resources :users, only: [:index] do
        collection do
          get :my_profile
        end
      end
  
      resources :users, param: :username, path: '', only: [:show, :create, :update, :destroy] do
        member do
          post :make_admin
          post :remove_admin
        end
  
        resources :reservations, only: [:index, :show, :create, :update, :destroy] do
          collection do
            get :date
            get :add_item
            get :remove_item
          end
        end
  
        resources :items, only: [:index, :show, :create, :destroy] do
          resources :reservations, only: [:index, :show]
          member do
            post :add_reservation
            post :remove_reservation
            get :reservations
          end
        end
      end
    end
  end
   # devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "api/v1/pages#index"
  

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
