class Users::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)

    if resource.save
      sign_up(resource_name, resource)
      redirect_to after_sign_up_path_for(resource)
    else
      clean_up_passwords(resource)
      set_minimum_password_length
      flash.now[:alert] = resource.errors.full_messages

      # Turboを無効化し、エラーメッセージを表示させる
      render 'devise/sessions/new', status: :unprocessable_entity
    end
  end
end
