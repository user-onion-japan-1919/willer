class ViewPermissionsController < ApplicationController
  before_action :authenticate_user!

  def create
    # フォームからのパラメータでユーザーを検索（同じ名前・誕生日のユーザーを探す）
    viewer = User.find_by(
      first_name: params[:view_permission][:first_name],
      first_name_furigana: params[:view_permission][:first_name_furigana],
      last_name: params[:view_permission][:last_name],
      last_name_furigana: params[:view_permission][:last_name_furigana],
      birthday: Date.new(params[:view_permission]['birthday(1i)'].to_i,
                         params[:view_permission]['birthday(2i)'].to_i,
                         params[:view_permission]['birthday(3i)'].to_i),
      blood_type: params[:view_permission][:blood_type]
    )

    # `view_permission_params` で取り出したデータをセット
    @view_permission = current_user.view_permissions.new(view_permission_params)
    @view_permission.viewer = viewer if viewer.present?

    if current_user.view_permissions.count >= 5
      flash[:alert] = '閲覧許可対象者は最大5人まで登録できます。'
    elsif @view_permission.save
      flash[:notice] = '閲覧許可対象者を登録しました。'
    else
      flash[:alert] = "登録に失敗しました: #{@view_permission.errors.full_messages.join(', ')}"
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
    params.require(:view_permission).permit(
      :first_name, :first_name_furigana, :last_name, :last_name_furigana,
      :birthday, :blood_type
    )
  end
end
