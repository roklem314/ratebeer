Rails.application.routes.draw do
  resources :places
  resources :memberships
  resources :beer_clubs
  resources :users
  resources :beers
  resources :breweries
  resources :ratings, only: [:index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]

  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  get 'places', to: 'places#index'
  get 'places', to: 'places#index'
  post 'places', to:'places#search'
  delete 'signout', to: 'sessions#destroy'

  root 'breweries#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
