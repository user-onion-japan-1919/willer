class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_view_permission, only: [:public_page] # <!-- 追記 --> 公開ページのアクセス制限を追加
  before_action :set_page_owner, only: [:index, :public_page] # <!-- 追記 --> ページ所有者を設定

  def index
    @note = current_user.notes.order(created_at: :desc).first || Note.new
    @view_accesses = ViewAccess.includes(:owner, :viewer).where(owner_id: current_user.id).to_a # <!-- 追記 -->

    # <!-- 追記開始 --> 親か子かで表示する閲覧履歴を切り替え
    if @page_owner.blank?
      Rails.logger.error '🚨 ページ所有者が設定されていません'
      flash[:alert] = 'ページ所有者が見つかりません。'
      @view_requests = []
      return
    end

    @view_requests = if current_user_is_owner?
                       ViewRequest.where(owner_id: current_user.id)
                     else
                       ViewRequest.where(viewer_id: current_user.id, owner_id: @page_owner.id)
                     end
    # <!-- 追記終了 -->
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

    # <!-- 追記 --> 閲覧履歴用のview_accesses
    @view_access_logs = ViewAccess.includes(:owner, :viewer)
                                  .where(owner_id: @user.id)
                                  .order(last_accessed_at: :desc)
                                  .to_a

    # アクセス拒否ユーザーを抽出
    @view_accesses = ViewAccess.includes(:owner, :viewer)
                               .where(owner_id: @user.id)
                               .order(last_rejected_at: :desc)
                               .to_a

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

  # <!-- 追記 --> ページ所有者を設定するメソッド
  def set_page_owner
    @page_owner = User.find_by(id: params[:owner_id]) || current_user
    Rails.logger.debug "👤 ページ所有者: #{@page_owner&.inspect || 'なし'}"
  end

  # <!-- 追記 --> 親ユーザー判定メソッド
  def current_user_is_owner?
    if @page_owner.blank?
      Rails.logger.error '🚨 current_user_is_owner?: @page_owner が nil です'
      return false
    end
    current_user.present? && current_user.id == @page_owner.id
  end

  # <!-- 追記 --> 公開ページアクセス権限の確認メソッド
  def check_view_permission
    @user = User.find_by(uuid: params[:uuid])
    if @user.nil?
      flash[:alert] = '公開ページは存在しません。'
      return render inline: "<script>alert('公開ページは存在しません。'); window.close();</script>".html_safe
    end

    # 公開者本人はアクセス許可
    return if current_user == @user

    # 公開者のview_permissionsからon_modeが「許可」のユーザーを取得
    permitted_users = @user.view_permissions.where(on_mode: '許可')

    # 許可されたユーザーの情報で完全一致するか確認
    is_permitted = permitted_users.any? do |vp|
      User.exists?(
        first_name: current_user.first_name,
        first_name_furigana: current_user.first_name_furigana,
        last_name: current_user.last_name,
        last_name_furigana: current_user.last_name_furigana,
        birthday: current_user.birthday,
        blood_type: current_user.blood_type
      ) && vp.first_name == current_user.first_name &&
        vp.first_name_furigana == current_user.first_name_furigana &&
        vp.last_name == current_user.last_name &&
        vp.last_name_furigana == current_user.last_name_furigana &&
        vp.birthday == current_user.birthday &&
        vp.blood_type == current_user.blood_type
    end

    return if is_permitted

    # <!-- 追記開始 --> アクセス拒否時にview_accessesを保存
    view_access = ViewAccess.find_or_initialize_by(viewer_id: current_user.id, owner_id: @user.id)
    view_access.rejected_count = (view_access.rejected_count || 0) + 1
    view_access.last_rejected_at = Time.current
    view_access.save
    # <!-- 追記終了 -->

    # ✅ 別ウインドウにエラー通知を表示
    render inline: <<-HTML.html_safe
      <script>
        alert('※アクセス権限がないため、あなたの個人ページへリダイレクトします。\\n→アクセスの履歴はURL公開者に通知されます。');
        window.location.href = '#{root_path}';
      </script>
    HTML
  end

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
