class Users::SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate(auth_options)
    if resource
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      redirect_to root_path
    else
      flash.now[:alert] = 'ログインに失敗しました。メールアドレスまたはパスワードが違います。'
      @email = params[:user][:email] # 入力したメールアドレスを保持
      render 'devise/sessions/new', status: :unprocessable_entity
    end
  end
end
