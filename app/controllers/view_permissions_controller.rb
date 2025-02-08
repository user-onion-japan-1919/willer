class ViewPermissionsController < ApplicationController
  before_action :authenticate_user!

  def create
    # フォームからのパラメータでユーザーを検索（同じ名前・誕生日のユーザーを探す）
    viewer = begin
      User.find_by(
        first_name: params[:view_permission][:first_name],
        first_name_furigana: params[:view_permission][:first_name_furigana],
        last_name: params[:view_permission][:last_name],
        last_name_furigana: params[:view_permission][:last_name_furigana],
        birthday: parse_birthday(params[:view_permission]), # ✅ `UsersController` に統一
        blood_type: params[:view_permission][:blood_type]
      )
    rescue StandardError
      nil
    end # **エラー回避: 日付が不正な場合 nil をセット**

    unless viewer
      flash[:alert] = '該当するユーザーが見つかりませんでした。'
      return redirect_to notes_path
    end

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
      :blood_type
    ).merge(
      birthday: parse_birthday(params[:view_permission]) # ✅ 統一
    )
  end

  # ✅ `UsersController` と統一した `birthday` 変換処理
  def parse_birthday(params)
    return unless params['birthday(1i)'].present? && params['birthday(2i)'].present? && params['birthday(3i)'].present?

    begin
      Date.new(
        params['birthday(1i)'].to_i,
        params['birthday(2i)'].to_i,
        params['birthday(3i)'].to_i
      )
    rescue StandardError
      nil
    end # **エラー回避**
  end
end
