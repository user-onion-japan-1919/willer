Rails.application.routes.draw do
  root to: "notes#index" # 仮のトップページ
  devise_for :users
end
