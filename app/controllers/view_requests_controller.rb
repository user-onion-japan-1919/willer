class ViewRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    Rails.logger.debug "📌 Received Params: #{params.inspect}" # デバッグ用ログ

    @view_request = ViewRequest.new(
      viewer_id: current_user.id,
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

    # **current_userの `view_requests` をすべて取得**
    view_requests = current_user.view_requests

    if view_requests.empty?
      flash[:alert] = '登録された閲覧申請がありません。'
      return redirect_to notes_path
    end

    updated_count = 0
    view_requests.each do |view_request|
      Rails.logger.debug "📌 処理中の閲覧申請: #{view_request.inspect}"

      # **`users` テーブルと完全一致するユーザーを検索**
      owner = User.where(
        first_name: view_request.first_name,
        first_name_furigana: view_request.first_name_furigana,
        last_name: view_request.last_name,
        last_name_furigana: view_request.last_name_furigana,
        birthday: view_request.birthday,
        blood_type: view_request.blood_type
      ).first # `.first` で最初の1件を取得

      if owner.nil?
        Rails.logger.error "⚠️ 公開者 (#{view_request.first_name} #{view_request.last_name}) が見つかりませんでした。"
        next
      end

      Rails.logger.debug "✅ 一致する公開者: #{owner.inspect}"

      # **公開ページURLを作成**
      public_page_url = "#{ENV['BASE_URL']}/public_page/#{owner.uuid}/#{owner.id + 150_150}"

      # **`view_requests` に `url` を保存**
      view_request.update(url: public_page_url)
      updated_count += 1
    end

    if updated_count > 0
      flash[:notice] = "#{updated_count} 件の公開ページURLを取得しました。"
    else
      flash[:alert] = '該当する公開者が見つかりませんでした。'
    end

    redirect_to notes_path
  end

  # ✅ 【追加】destroyアクション
  def destroy
    @view_request = ViewRequest.find(params[:id])

    if @view_request.destroy
      flash[:notice] = '閲覧リクエストを削除しました。'
    else
      flash[:alert] = '閲覧リクエストの削除に失敗しました。'
    end

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
