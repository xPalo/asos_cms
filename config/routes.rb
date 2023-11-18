Rails.application.routes.draw do
  root "home#index"
  devise_for :users
  resources :users, except: [:edit, :update, :destroy] do
    resources :messages, only: [:new, :create]
  end
  resources :messages, only: [:index, :show, :destroy]
  resources :settings, only: [:edit, :update]
  resources :posts do
    member do
      get :new_comment
      post :create_comment
      post :create_vote
    end
  end
  resources :comments, only: [:edit, :update, :destroy]
  match "lang/:locale", to: "home#change_locale", as: :change_locale, via: [:get]
  get "/explore", to: "home#explore"
end
