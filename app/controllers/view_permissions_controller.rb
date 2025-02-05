class ViewPermissionsController < ApplicationController
  before_action :authenticate_user!

  def create
    @view_permission = current_user.view_permissions.new(view_permission_params)
    if current_user.view_permissions.count >= 5
      flash[:alert] = '閲覧許可対象者は最大5人まで登録できます。'
    elsif @view_permission.save
      flash[:notice] = '閲覧許可対象者を登録しました。'
    else
      flash[:alert] = '登録に失敗しました。'
    end
    redirect_to notes_path
  end

  def destroy
    @view_permission = current_user.view_permissions.find(params[:id])
    if @view_permission.destroy
      flash[:notice] = '閲覧許可対象者を削除しました。'
    else
      flash[:alert] = '削除に失敗しました。'
    end
    redirect_to notes_path
  end

  private

  def view_permission_params
    params.require(:view_permission).permit(:last_name, :last_name_furigana, :first_name, :first_name_furigana, :birthday,
                                            :blood_type)
  end
end
