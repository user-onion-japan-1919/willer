class NotesController < ApplicationController
  before_action :authenticate_user!

  def public_page
    @user = User.find_by(uuid: params[:uuid]) # UUID から公開者(Aさん)を取得
    @viewer = current_user # 閲覧者(Bさん)
    @today = Time.current # 本日の日付（時間・分まで表示）

    if @user.nil?
      flash[:alert] = '指定された公開ページは存在しません。'
      return redirect_to root_path
    end

    # **閲覧履歴の取得**
    @view_accesses = ViewAccess.where(parent_id: @user.id).order(last_accessed_at: :desc)
    @view_accesses ||= [] # **nilガードを追加**

    # **閲覧履歴の更新**
    view_access = ViewAccess.find_or_create_by(user_id: @viewer.id, parent_id: @user.id) do |va|
      va.public_page_url = public_page_url(uuid: @user.uuid, custom_id: @user.id + 150_150)
      va.access_count = 0
      va.last_accessed_at = Time.current # **最初のアクセス日時を記録**
    end

    return if view_access.update(last_accessed_at: Time.current, access_count: view_access.access_count + 1)

    flash[:alert] = '閲覧履歴の更新に失敗しました。'
  end
end
