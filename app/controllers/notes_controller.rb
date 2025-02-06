class NotesController < ApplicationController
  before_action :authenticate_user!

  def public_page
    @user = User.find_by(uuid: params[:uuid]) # UUID から公開者を取得
    @viewer = current_user # 閲覧者(Bさん)
    @today = Time.current # 本日の日付（時間・分まで表示）

    if @user.nil?
      flash[:alert] = '指定された公開ページは存在しません。'
      return redirect_to root_path
    end

    # **閲覧履歴の取得**
    @view_requests = ViewRequest.where(parent_id: @user.id).order(last_accessed_at: :desc)
    @view_requests = [] if @view_requests.nil? # **追加: nil ガード**

    # **閲覧履歴の更新**
    view_request = ViewRequest.find_by(user_id: @viewer.id, parent_id: @user.id)
    if view_request
      unless view_request.update(last_accessed_at: Time.current, access_count: view_request.access_count + 1)
        flash[:alert] = '閲覧履歴の更新に失敗しました。'
      end
    else
      flash[:alert] = '閲覧履歴を更新できませんでした。'
    end
  end
end
