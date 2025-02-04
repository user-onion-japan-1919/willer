class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    notes_path # ログイン後に遺言一覧ページへ
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
  end
end
