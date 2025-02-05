class ViewRequestsController < ApplicationController
  before_action :authenticate_user!

  def index
    @view_requests = current_user.view_requests
  end

  def new
    @view_request = ViewRequest.new
  end

  def create
    @view_request = current_user.view_requests.build(view_request_params)

    if @view_request.save
      flash[:notice] = '閲覧申請を送信しました。'
      redirect_to view_requests_path
    else
      flash[:alert] = '申請に失敗しました。'
      render :new
    end
  end

  private

  def view_request_params
    params.require(:view_request).permit(
      :parent_id, :viewer_first_name, :viewer_first_name_furigana,
      :viewer_last_name, :viewer_last_name_furigana, :relationship,
      :viewer_email, :viewer_birthday, :viewer_blood_type,
      :viewer_address, :viewer_phone_number
    )
  end
end
