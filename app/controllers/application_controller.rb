class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    notes_path # ログイン後に遺言一覧ページへ
  end

  def after_sign_out_path_for(resource)
    root_path # ログアウト後のリダイレクト先
  end
end
