Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'register', to: 'users#new'
  get 'register/:invitation_token', to: 'users#new_with_invitation_token', as: 'register_with_token'
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'
  get 'home', to: 'videos#index'
  get 'my_queue', to: 'queue_items#index'
  get 'people', to: 'relationships#index'
  resources :relationships, only: [:create, :destroy]

  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end
  resources :categories, only: [:show], path: 'genres'
  resources :users, only: [:show, :create]
  resources :sessions, only: [:create]
  resources :queue_items, only: [:create, :destroy]
  post 'update_queue', to: 'queue_items#update_queue'
  post 'drag_sort', to: 'queue_items#drag_sort'
  post 'update_rating', to: 'queue_items#update_rating'

  resources :forgot_passwords, only: [:create]
  get 'forgot_password', to: 'forgot_passwords#new'
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'

  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: 'password_resets#expired_token'

  resources :invitations, only: [:new, :create]
  
  get 'ui(/:action)', controller: 'ui'
end
