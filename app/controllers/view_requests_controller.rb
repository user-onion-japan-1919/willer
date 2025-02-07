class ViewRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    Rails.logger.debug "📌 Received Params: #{params.inspect}" # デバッグ用ログ

    # `parent_id` を取得（フォームから渡された値を使用）
    parent_id = params[:view_request][:parent_id].present? ? params[:view_request][:parent_id].to_i : nil
    owner = User.find_by(id: parent_id)

    unless owner
      flash[:alert] = '公開者の情報が見つかりません。'
      return redirect_to notes_path
    end

    # **ログインユーザーが公開者自身の場合はエラー**
    if current_user.id == owner.id
      flash[:alert] = '自分自身を閲覧申請することはできません。'
      return redirect_to notes_path
    end

    Rails.logger.debug "📌 見つかった公開者: #{owner.inspect}"

    # **既存の ViewRequest がある場合は保存せずリダイレクト**
    existing_request = ViewRequest.find_by(user_id: current_user.id, parent_id: owner.id)
    if existing_request
      flash[:alert] = 'この公開者への閲覧申請は既に登録されています。'
      return redirect_to notes_path
    end

    # **閲覧リクエストを作成**
    @view_request = ViewRequest.new(
      user_id: current_user.id,
      parent_id: owner.id,
      first_name: owner.first_name,
      first_name_furigana: owner.first_name_furigana,
      last_name: owner.last_name,
      last_name_furigana: owner.last_name_furigana, # ← ここにカンマを追加
      birthday: owner.birthday,
      blood_type: owner.blood_type,
      relationship: params[:view_request][:relationship]
    )

    if @view_request.save
      flash[:notice] = '閲覧申請を送信しました。'
    else
      flash[:alert] = "申請に失敗しました: #{@view_request.errors.full_messages.join(', ')}"
    end

    redirect_to notes_path
  end

  private

  def view_request_params
    params.require(:view_request).permit(
      :first_name, :first_name_furigana, :last_name, :last_name_furigana,
      :birthday, :blood_type, :relationship, :parent_id
    )
  end
end
