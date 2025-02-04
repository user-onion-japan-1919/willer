class ApplicationController < ActionController::Base
  before_action :basic_auth
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['BASIC_AUTH_USER'] && password == ENV['BASIC_AUTH_PASSWORD'] # 環境変数を読み込む記述に変更
    end
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || notes_path || root_path # ログイン後に遺言一覧ページへ
  end

  def after_sign_out_path_for(resource)
    root_path # ログアウト後のリダイレクト先
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
                                        :first_name, :first_name_furigana, :last_name, :last_name_furigana,
                                        :birthday, :blood_type, :address, :phone_number
                                      ])
    devise_parameter_sanitizer.permit(:account_update, keys: [
                                        :first_name, :first_name_furigana, :last_name, :last_name_furigana,
                                        :birthday, :blood_type, :address, :phone_number
                                      ])
  end
end
