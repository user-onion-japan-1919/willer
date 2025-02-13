class ViewPermissionsController < ApplicationController
  before_action :authenticate_user!

  # ✅ 許可設定の一括更新API
  def update_all
    ActiveRecord::Base.transaction do
      params[:view_permissions].each do |vp_params|
        view_permission = current_user.view_permissions.find(vp_params[:id])
        view_permission.update!(on_mode: vp_params[:on_mode], on_timer_value: vp_params[:on_timer_value],
                                on_timer_unit: vp_params[:on_timer_unit])
      end
    end
    render json: { success: true }
  rescue ActiveRecord::RecordInvalid => e
    render json: { success: false, errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def create
    # 📌 フォームのパラメータを取得
    permission_params = view_permission_params

    # 📌 `users` テーブルに一致するユーザーを検索（存在すれば `viewer_id` にセット）
    viewer = User.find_by(
      first_name: permission_params[:first_name],
      first_name_furigana: permission_params[:first_name_furigana],
      last_name: permission_params[:last_name],
      last_name_furigana: permission_params[:last_name_furigana],
      birthday: permission_params[:birthday],
      blood_type: permission_params[:blood_type]
    )

    # 📌 `view_permissions` に保存
    @view_permission = current_user.view_permissions.new(permission_params)
    @view_permission.viewer_id = viewer.id if viewer.present? # ✅ 存在すれば `viewer_id` をセット

    if current_user.view_permissions.count >= 5
      flash[:alert] = '閲覧許可対象者は最大5人まで登録できます。'
    elsif @view_permission.save
      flash[:notice] =
        viewer.present? ? "閲覧許可対象者を登録しました。（登録済みユーザー: #{viewer.first_name} #{viewer.last_name}）" : '閲覧許可対象者を登録しました。（未登録ユーザー）'
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
      :first_name, :first_name_furigana, :last_name, :last_name_furigana, :blood_type
    ).merge(
      birthday: parse_birthday(params[:view_permission]) # ✅ `birthday` のフォーマット統一
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
