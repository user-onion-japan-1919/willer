Rails.application.routes.draw do
 
 require 'devise'
  devise_for :users
  
    root to: "items#index" 
 resources :items  do# 必要に応じて追加
 resources :orders, only: [:new, :create] # 購入履歴（index）が必要なら追加
end
end