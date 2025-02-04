Rails.application.routes.draw do
  root to: "notes#index" # 仮のトップページ
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  resources :notes, only: [:index, :new, :create, :show] # ここに適宜必要なアクションを追加
end