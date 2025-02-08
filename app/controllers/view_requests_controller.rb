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
      first_name: params[:view_request][:first_name],
      first_name_furigana: params[:view_request][:first_name_furigana],
      last_name: params[:view_request][:last_name],
      last_name_furigana: params[:view_request][:last_name_furigana],
      birthday: parse_birthday(params[:view_request]), # ✅ `UsersController` に統一
      blood_type: params[:view_request][:blood_type],
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
      :blood_type, :relationship, :parent_id
    ).merge(
      birthday: parse_birthday(params[:view_request]) # ✅ 統一
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
