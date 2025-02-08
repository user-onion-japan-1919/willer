class ViewRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    Rails.logger.debug "📌 Received Params: #{params.inspect}" # デバッグ用ログ

    # **`parent_id` を登録時に指定しない**
    @view_request = ViewRequest.new(
      user_id: current_user.id,
      first_name: params[:view_request][:first_name],
      first_name_furigana: params[:view_request][:first_name_furigana],
      last_name: params[:view_request][:last_name],
      last_name_furigana: params[:view_request][:last_name_furigana],
      birthday: parse_birthday(params[:view_request]), # ✅ `UsersController` に統一
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

  private

  def view_request_params
    params.require(:view_request).permit(
      :first_name, :first_name_furigana, :last_name, :last_name_furigana,
      :blood_type, :relationship
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
