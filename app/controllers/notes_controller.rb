class NotesController < ApplicationController
  before_action :authenticate_user!

  def public_page
    @user = User.find_by(uuid: params[:uuid]) # UUID から公開者(Aさん)を取得
    @viewer = current_user # 閲覧者(Bさん or Aさん)
    @today = Time.current # 本日の日付（時間・分まで表示）

    if @user.nil?
      flash[:alert] = '指定された公開ページは存在しません。'
      return redirect_to root_path
    end

    # **閲覧履歴の取得**
    @view_accesses = ViewAccess.where(parent_id: @user.id).order(last_accessed_at: :desc)
    @view_accesses ||= [] # **nilガードを追加**

    # **Aさん自身が自分の公開ページを開いた場合にも履歴を記録する**
    view_access = ViewAccess.find_or_initialize_by(user_id: @viewer.id, parent_id: @user.id)

    # 初回アクセス時にURLを保存
    if view_access.new_record?
      view_access.public_page_url = public_page_url(uuid: @user.uuid, custom_id: @user.id + 150_150)
      view_access.access_count = 0
      view_access.last_accessed_at = Time.current
      view_access.save
    end

    # **履歴の更新**
    if view_access.update(last_accessed_at: Time.current, access_count: view_access.access_count + 1)
      Rails.logger.debug "📌 閲覧履歴更新成功: #{view_access.inspect}"
    else
      Rails.logger.debug "⚠️ 閲覧履歴の更新に失敗: #{view_access.errors.full_messages}"
      flash[:alert] = '閲覧履歴の更新に失敗しました。'
    end
  end
end
