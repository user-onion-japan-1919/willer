Rails.application.routes.draw do
  root to: "notes#index" # 仮のトップページ
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  resources :notes, only: [:index, :new, :create, :show] # ここに適宜必要なアクションを追加


  # 検索機能用のルートを追加
  get 'search_users', to: 'users#search', as: :search_users
end