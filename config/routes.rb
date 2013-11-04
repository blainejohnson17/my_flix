Myflix::Application.routes.draw do
  root to: 'videos#index'
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'

  resources :videos, only: [:show]
  resources :categories, only: [:show], path: 'genres'
end