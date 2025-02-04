class Users::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)

    if resource.save
      sign_up(resource_name, resource)
      respond_to do |format|
        format.html { redirect_to after_sign_up_path_for(resource), notice: 'アカウント登録が完了しました' }
        format.turbo_stream
      end
    else
      clean_up_passwords(resource)
      set_minimum_password_length
      respond_to do |format|
        format.html { render 'devise/sessions/new', status: :unprocessable_entity }
        format.turbo_stream
      end
    end
  end
end
