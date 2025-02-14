class NotesController < ApplicationController
  before_action :authenticate_user!

  def index
    @note = current_user.notes.order(created_at: :desc).first || Note.new
  end

  def create
    @note = current_user.notes.order(created_at: :desc).first_or_initialize
    @note.assign_attributes(note_params)

    if @note.save
      redirect_to notes_path, notice: 'ノートを保存しました。'
    else
      render :index, status: :unprocessable_entity
    end
  end

  def update
    @note = current_user.notes.find(params[:id])
    if @note.update(note_params)
      Rails.logger.debug "✅ 更新成功: #{@note.inspect}"
      redirect_to notes_path, notice: 'ノートを更新しました。'
    else
      Rails.logger.debug "⚠️ 更新失敗: #{@note.errors.full_messages}"
      flash.now[:alert] = 'ノートの更新に失敗しました。'
      render :index, status: :unprocessable_entity
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

  # ✅ **PDFダウンロードアクションを修正**
  def download_pdf
    @note = current_user.notes.find_by(id: params[:id]) || Note.new(issue_1: '未入力', title_1: '未入力', content_1: '未入力')

    pdf = NotePdf.new(@note)
    send_data pdf.render, filename: "note_#{params[:id] || 'empty'}.pdf",
                          type: 'application/pdf',
                          disposition: 'attachment'
  end

  private

  def note_params
    params.require(:note).permit(
      :type_1, :type_2, :type_3, :type_4, :type_5,
      :issue_1, :issue_2, :issue_3, :issue_4, :issue_5,
      :requirement_1, :requirement_2, :requirement_3, :requirement_4, :requirement_5,
      :title_1, :title_2, :title_3, :title_4, :title_5,
      :content_1, :content_2, :content_3, :content_4, :content_5,
      :metadata
    )
  end
end
