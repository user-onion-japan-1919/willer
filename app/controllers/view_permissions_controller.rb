class ViewPermissionsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:update_on_mode, :update_on_timer_value_and_unit, :hold]

  # ✅ 許可設定の一括更新API
  def update_all
    ActiveRecord::Base.transaction do
      params[:view_permissions].each do |vp_params|
        view_permission = current_user.view_permissions.find(vp_params[:id])
        view_permission.update!(
          on_mode: vp_params[:on_mode],
          on_timer_value: vp_params[:on_timer_value],
          on_timer_unit: vp_params[:on_timer_unit]
        )
      end
    end
    render json: { success: true }
  rescue ActiveRecord::RecordInvalid => e
    render json: { success: false, errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  # ✅ 新規作成API
  def create
    permission_params = view_permission_params

    # 📌 `users` テーブルに一致するユーザーを検索
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
    @view_permission.viewer_id = viewer.id if viewer.present?

    if current_user.view_permissions.count >= 5
      flash[:alert] = '閲覧許可対象者は最大5人まで登録できます。'
    elsif @view_permission.save
      flash[:notice] = if viewer.present?
                         "閲覧許可対象者を登録しました。（登録済みユーザー: #{viewer.first_name} #{viewer.last_name}）"
                       else
                         '閲覧許可対象者を登録しました。（未登録ユーザー）'
                       end
    else
      flash[:alert] = "登録に失敗しました: #{@view_permission.errors.full_messages.join(', ')}"
    end

    redirect_to notes_path
  end

  # ✅ 「保留して保存」ボタン機能
  def hold
    viewer = User.find_by(id: params[:viewer_id])

    if viewer
      # ✅ `view_permissions` に保存
      ViewPermission.find_or_create_by!(
        owner_id: current_user.id,
        viewer_id: viewer.id
      ) do |vp|
        vp.first_name = viewer.first_name
        vp.first_name_furigana = viewer.first_name_furigana
        vp.last_name = viewer.last_name
        vp.last_name_furigana = viewer.last_name_furigana
        vp.birthday = viewer.birthday
        vp.blood_type = viewer.blood_type
        vp.on_mode = '拒否' # デフォルトは「拒否」
      end

      # ✅ `view_accesses` の更新: 拒否回数をリセット & アクセス回数を+1
      view_access = ViewAccess.find_or_initialize_by(viewer_id: viewer.id, owner_id: current_user.id)
      view_access.update!(
        rejected_count: 0, # 拒否回数をリセット
        access_count: view_access.access_count.to_i + 1 # アクセス回数を+1
      )

      render json: { status: 'success' }
    else
      render json: { status: 'error', message: 'ユーザーが見つかりません' }, status: :unprocessable_entity
    end
  end

  # ✅ モード更新API
  def update_on_mode
    @view_permission = ViewPermission.find(params[:id])
    if @view_permission.update(on_mode: params[:on_mode])
      render json: { success: true }
    else
      render json: { success: false, errors: @view_permission.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ タイマー更新API
  def update_on_timer_value_and_unit
    @view_permission = ViewPermission.find(params[:id])
    if @view_permission.update(
      on_timer_value: params[:on_timer_value],
      on_timer_unit: params[:on_timer_unit]
    )
      render json: { success: true }
    else
      render json: { success: false, errors: @view_permission.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ 閲覧許可削除API
  def destroy
    view_permission = current_user.view_permissions.find_by(id: params[:id])

    if view_permission&.destroy
      head :no_content # ✅ 成功時は即レスポンスで終了
    else
      render json: { success: false, message: '削除に失敗しました。' }, status: :unprocessable_entity
    end
  end

  # ✅ 全ユーザーの拒否回数をリセットするアクション
  def clear_rejections
    ViewAccess.where(owner_id: current_user.id).update_all(rejected_count: 0)
    render json: { status: 'success', message: '全てのアクセス拒否回数をリセットしました。' }
  rescue StandardError => e
    render json: { status: 'error', message: e.message }, status: :unprocessable_entity
  end


  # ✅ 拒否回数をリセットするアクション
  def clear_rejection
    view_access = ViewAccess.find_by(viewer_id: params[:viewer_id], owner_id: current_user.id)

    if view_access
      view_access.update!(rejected_count: 0)
      render json: { success: true, message: "拒否回数をリセットしました。" }, status: :ok
    else
      render json: { success: false, message: "対象のユーザーが見つかりませんでした。" }, status: :not_found
    end
  rescue StandardError => e
    render json: { success: false, message: "エラー: #{e.message}" }, status: :unprocessable_entity
  end
end

  private

  # ✅ Strong Parameters
  def view_permission_params
    params.require(:view_permission).permit(
      :first_name, :first_name_furigana,
      :last_name, :last_name_furigana,
      :blood_type
    ).merge(
      birthday: parse_birthday(params[:view_permission])
    )
  end

  # ✅ `birthday` をパラメータから正しいフォーマットに変換
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
    end
  end
end
