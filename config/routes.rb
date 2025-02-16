


require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq' # Sidekiqの管理画面を/sidekiqで開けるようにする


  root to: "notes#index" # 仮のトップページ
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "sessions"
  }

  resources :users, only: [:update]

  resources :view_permissions, only: [:index, :new, :create, :destroy] do
    collection do
      post "request_access"
      post :clear_rejections # ✅ 全拒否リセット用エンドポイント
    end
    member do
      patch "update_on_mode"                  # モード更新用ルート
      patch "update_on_timer_value_and_unit"  # タイマー更新用ルート（修正済み）
    end
  end

  resources :view_requests, only: [:index, :new, :create, :destroy] do
    collection do
      post "request_access"
    end
  end

  resources :notes, only: [:index, :create, :edit, :update, :destroy] do
    member do
      get "download_pdf"
    end
  end

  get "/search_users", to: "users#search", as: :search_users
  get "/public_page/:uuid/:custom_id", to: "notes#public_page", as: :public_page
  get 'notes/public_page/:owner_id', to: 'notes#public_page', as: 'public_note'

  post "/view_permissions/hold", to: "view_permissions#hold", as: :view_permissions_hold

end