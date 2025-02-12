class ViewRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    Rails.logger.debug "📌 Received Params: #{params.inspect}" # デバッグ用ログ

    @view_request = ViewRequest.new(
      user_id: current_user.id,
      first_name: params[:view_request][:first_name],
      first_name_furigana: params[:view_request][:first_name_furigana],
      last_name: params[:view_request][:last_name],
      last_name_furigana: params[:view_request][:last_name_furigana],
      birthday: parse_birthday(params[:view_request]),
      blood_type: params[:view_request][:blood_type],
      relationship: params[:view_request][:relationship]
    )

    if @view_request.save
      flash[:notice] = '閲覧申請を登録しました。'
    else
      flash[:alert] = "申請に失敗しました: #{@view_request.errors.full_messages.join(', ')}"
    end

    redirect_to notes_path
  end

  # ✅ **公開ページURLの取得処理（`view_requests` に保存された情報から検索）**
  def request_access
    Rails.logger.debug "📌 Received Params: #{params.inspect}" # デバッグ用ログ

    # `view_request_id` が正しく渡っているか確認
    if params[:view_request_id].blank?
      flash[:alert] = '閲覧申請IDが指定されていません。'
      return redirect_to notes_path
    end

    # `view_requests` から `view_request_id` に対応するデータを取得
    view_request = current_user.view_requests.find_by(id: params[:view_request_id])

    unless view_request
      Rails.logger.error "⚠️ 指定された view_request_id (#{params[:view_request_id]}) の閲覧申請が見つかりません"
      flash[:alert] = '該当する閲覧申請が見つかりません。'
      return redirect_to notes_path
    end

    # `users` テーブルと完全一致するユーザーを検索（公開者の特定）
    owner = User.find_by(
      first_name: view_request.first_name,
      first_name_furigana: view_request.first_name_furigana,
      last_name: view_request.last_name,
      last_name_furigana: view_request.last_name_furigana,
      birthday: view_request.birthday,
      blood_type: view_request.blood_type
    )

    unless owner
      Rails.logger.error "⚠️ 公開者 (#{view_request.first_name} #{view_request.last_name}) が見つかりませんでした。"
      flash[:alert] = '該当する公開者が見つかりませんでした。'
      return redirect_to notes_path
    end

    Rails.logger.debug "📌 照合された公開者: #{owner.inspect}"

    # **公開ページURLを作成**
    public_page_url = "https://example.com/public_page/#{owner.uuid}/#{owner.id + 150_150}"

    # `view_accesses` にデータを保存 or 更新
    view_access = ViewAccess.find_or_initialize_by(owner_id: owner.id, viewer_id: current_user.id)
    view_access.public_page_url = public_page_url
    view_access.save!

    flash[:notice] = '公開ページURLを取得しました。'
    redirect_to notes_path
  end

  private

  def view_request_params
    params.require(:view_request).permit(
      :first_name, :first_name_furigana, :last_name, :last_name_furigana,
      :blood_type, :relationship
    ).merge(
      birthday: parse_birthday(params[:view_request])
    )
  end

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
