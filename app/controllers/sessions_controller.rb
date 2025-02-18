class SessionsController < Devise::SessionsController
  def destroy
    current_user.set_last_logout if current_user
    super
  end
end
