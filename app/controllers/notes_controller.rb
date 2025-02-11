class NotesController < ApplicationController
  before_action :authenticate_user!


  def index
    @notes = current_user.notes
    @note = @notes.first || Note.new
  end

  def show
    @note = current_user.note || current_user.create_note
  end



  def update
    @note = current_user.note

    if @note.update(note_params)
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = "ノートが更新されました。" }
        format.html { redirect_to note_path, notice: "ノートが更新されました。" }
      end
    else
      respond_to do |format|
        format.turbo_stream { flash.now[:alert] = "ノートの更新に失敗しました。" }
        format.html { render :show, status: :unprocessable_entity }
      end
    end
  end




  def public_page
    @user = User.find_by(uuid: params[:uuid]) # UUID から公開者(Aさん)を取得
    @viewer = current_user # 閲覧者(Bさん or Aさん)
    @today = Time.current # 本日の日付（時間・分まで表示）

    if @user.nil?
      flash[:alert] = '指定された公開ページは存在しません。'
      return redirect_to root_path
    end

 # **公開者のノート情報を取得（閲覧のみ）**
 @notes = Note.where(user_id: @user.id).to_a # `nil` を防ぐために空配列を返す


    # **閲覧履歴の取得**
    @view_accesses = ViewAccess.includes(:owner, :viewer)
                               .where(owner_id: @user.id)
                               .order(last_accessed_at: :desc)
                               .to_a # `nil` の場合は空配列にする

    # **閲覧履歴の更新**
    view_access = ViewAccess.find_or_initialize_by(viewer_id: @viewer.id, owner_id: @user.id)

    # 初回アクセス時にURLを保存
    if view_access.new_record?
      view_access.public_page_url = public_page_url(uuid: @user.uuid, custom_id: @user.id + 150_150)
      view_access.access_count = 0
      view_access.last_accessed_at = Time.current
      view_access.save
    end

    # **履歴の更新**
    if view_access.update(last_accessed_at: Time.current, access_count: (view_access.access_count || 0) + 1)
      Rails.logger.debug "📌 閲覧履歴更新成功: #{view_access.inspect}"
    else
      Rails.logger.debug "⚠️ 閲覧履歴の更新に失敗: #{view_access.errors.full_messages}"
      flash[:alert] = '閲覧履歴の更新に失敗しました。'
    end
  end
end

def note_params
  params.require(:note).permit(:issue_1, :tytle_1, :content_1, :issue_2, :tytle_2, :content_2)
end
