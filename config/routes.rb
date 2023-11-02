  Rails.application.routes.draw do
    devise_for :users
    resources :users, only: [:show] # ユーザーマイページへのルーティング
    get 'hello/index' => 'hello#index'
    get 'hello/link' => 'hello#link'
    root "posts#index"

    resources :posts do
      resources :likes, only: [:create, :destroy]
      resources :comments, only: [:create]
  end
end