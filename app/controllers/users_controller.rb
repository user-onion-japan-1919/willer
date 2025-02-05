class UsersController < ApplicationController
  before_action :authenticate_user!

  def update
    if current_user.update(user_params)
      flash[:notice] = '登録情報が更新されました。'
      redirect_to notes_path
    else
      flash[:alert] = '登録情報の更新に失敗しました。'
      render 'notes/index'
    end
  end

  def search
    @users = User.where('email LIKE ? OR first_name LIKE ? OR last_name LIKE ?',
                        "%#{params[:search_query]}%", "%#{params[:search_query]}%", "%#{params[:search_query]}%")
    render json: @users
  end

  private

  def user_params
    params.require(:user).permit(
      :email, :last_name, :last_name_furigana, :first_name, :first_name_furigana,
      :birthday, :blood_type, :phone_number, :address
    )
  end
end
