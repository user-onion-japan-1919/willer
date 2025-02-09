Rails.application.routes.draw do
  root to: "notes#index" # 仮のトップページ
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  resources :users, only: [:update]

  resources :view_permissions, only: [:index, :new, :create, :destroy] do
    collection do
      post "request_access"
    end
  end

  resources :view_requests, only: [:index, :new, :create, :destroy] do
    collection do
      post "request_access"
    end
  end

  resources :notes, only: [:index, :new, :create, :show] do
    member do
      get "download_pdf"
    end
  end

  get "/search_users", to: "users#search", as: :search_users
  get "/public_page/:uuid/:custom_id", to: "notes#public_page", as: :public_page
end