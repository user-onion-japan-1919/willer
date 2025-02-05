class ViewPermissionsController < ApplicationController
  before_action :authenticate_user!

  def create
    permitted_params = params.permit(:last_name, :last_name_furigana, :first_name, :first_name_furigana, :birthday, :blood_type)
    matched_user = User.find_by(permitted_params)

    if matched_user
      current_user.view_permissions.create(viewer_id: matched_user.id)
      redirect_to notes_path, notice: '閲覧を許可しました'
    else
      redirect_to notes_path, alert: '一致するユーザーが見つかりませんでした'
    end
  end
end
