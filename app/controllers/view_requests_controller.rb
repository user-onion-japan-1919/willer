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
      relationship: params[:view_request][:relationship],
      url: nil # 初回作成時は `null`
    )

    if @view_request.save
      flash[:notice] = '閲覧申請を登録しました。'
    else
      flash[:alert] = "申請に失敗しました: #{@view_request.errors.full_messages.join(', ')}"
    end

    redirect_to notes_path
  end

  # ✅ **公開ページURLの取得処理（複数の `view_requests` を一括処理）**
  def request_access
    Rails.logger.debug "📌 Received Params: #{params.inspect}" # デバッグ用ログ

    # **ユーザーの `view_requests` をすべて取得**
    view_requests = current_user.view_requests

    if view_requests.empty?
      flash[:alert] = '登録された閲覧申請がありません。'
      return redirect_to notes_path
    end

    updated_count = 0
    view_requests.each do |view_request|
      # **`users` テーブルと完全一致するユーザーを検索**
      owner = User.find_by(
        first_name: view_request.first_name,
        first_name_furigana: view_request.first_name_furigana,
        last_name: view_request.last_name,
        last_name_furigana: view_request.last_name_furigana,
        birthday: view_request.birthday,
        blood_type: view_request.blood_type
      )

      if owner
        # **公開ページURLを作成**
        public_page_url = "http://localhost:3000/public_page/#{owner.uuid}/#{owner.id + 150_150}"

        # **`view_requests` に `url` を保存**
        view_request.update(url: public_page_url)
        updated_count += 1
      end
    end

    if updated_count > 0
      flash[:notice] = "#{updated_count} 件の公開ページURLを取得しました。"
    else
      flash[:alert] = "該当する公開者が見つかりませんでした。"
    end

    redirect_to notes_path
  end

  def destroy
    view_request = current_user.view_requests.find_by(id: params[:id])

    if view_request
      view_request.destroy
      flash[:notice] = "閲覧申請を削除しました。"
    else
      flash[:alert] = "削除対象の閲覧申請が見つかりません。"
    end

    redirect_to notes_path
  end

  private

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