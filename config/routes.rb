Rails.application.routes.draw do
  root "home#index"
  devise_for :users
  resources :users, except: [:edit, :update, :destroy]
  resources :settings, only: [:edit, :update]
  resources :posts
  resources :comments, only: [:new, :create, :edit, :update, :destroy]
  match "lang/:locale", to: "home#change_locale", as: :change_locale, via: [:get]
  get "/explore", to: "home#explore"
end
