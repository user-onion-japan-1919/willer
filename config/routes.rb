Rails.application.routes.draw do
  root to: "notes#index" # 仮のトップページ
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  resources :users, only: [:update] 
  resources :view_permissions, only: [:create, :destroy]
  resources :view_requests, only: [:index, :new, :create, :destroy]
  resources :notes, only: [:index, :new, :create, :show] # ここに適宜必要なアクションを追加


  # 検索機能用のルートを追加
  get '/search_users', to: 'users#search', as: :search_users


  #  「あなたの公開ページ」のルートを追加
  get "/public_page", to: "notes#public_page"

  # 閲覧リクエストの処理
  post "/request_access", to: "view_requests#request_access"
  
end