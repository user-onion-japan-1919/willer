class ViewRequestsController < ApplicationController
  before_action :authenticate_user!

  def index
    @view_requests = current_user.view_requests
  end

  def new
    @view_request = ViewRequest.new
    @parent = current_user # 現在のユーザーを親として設定
  end

  def create
    Rails.logger.debug "📌 Received Params: #{params.inspect}" # デバッグ用ログ

    @view_request = ViewRequest.new(view_request_params)
    @view_request.parent_id = current_user.id # parent_id に current_user.id をセット

    if @view_request.save
      flash[:notice] = '閲覧申請を送信しました。'
      redirect_to view_requests_path
    else
      flash[:alert] = "申請に失敗しました: #{@view_request.errors.full_messages.join(', ')}"
      render :new
    end
  end

  private

  def view_request_params
    modified_params = params.require(:view_request).permit(
      :parent_id, :viewer_first_name, :viewer_first_name_furigana,
      :viewer_last_name, :viewer_last_name_furigana, :relationship,
      :viewer_email, :viewer_blood_type, :viewer_address, :viewer_phone_number
    )

    # `birthday(1i)`, `birthday(2i)`, `birthday(3i)` の形式で送られている場合
    if params[:view_request]['birthday(1i)'].present? &&
       params[:view_request]['birthday(2i)'].present? &&
       params[:view_request]['birthday(3i)'].present?

      modified_params[:viewer_birthday] = Date.new(
        params[:view_request]['birthday(1i)'].to_i,
        params[:view_request]['birthday(2i)'].to_i,
        params[:view_request]['birthday(3i)'].to_i
      )
    end

    modified_params
  end
end
