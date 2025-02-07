class ViewRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    Rails.logger.debug "📌 Received Params: #{params.inspect}" # デバッグ用ログ

    # `parent_id` を整数として取得
    parent_id = params[:view_request][:parent_id].to_i
    owner = User.find_by(id: parent_id)

    unless owner
      flash[:alert] = '公開者の情報が見つかりません。'
      return redirect_to notes_path
    end

    # **ログインユーザーが公開者自身の場合はエラー**
    if current_user.id == owner.id
      flash[:alert] = '自分自身を閲覧申請することはできません。'
      return redirect_to notes_path
    end

    Rails.logger.debug "📌 見つかった公開者: #{owner.inspect}"

    # **既存の ViewRequest がある場合は保存せずリダイレクト**
    existing_request = ViewRequest.find_by(user_id: current_user.id, parent_id: owner.id)
    if existing_request
      flash[:alert] = 'この公開者への閲覧申請は既に登録されています。'
      return redirect_to notes_path
    end

    # **閲覧リクエストを作成**
    @view_request = ViewRequest.new(
      user_id: current_user.id,
      parent_id: owner.id,
      first_name: owner.first_name,
      first_name_furigana: owner.first_name_furigana,
      last_name: owner.last_name,
      last_name_furigana: owner.last_name_furigana,
      birthday: owner.birthday,
      blood_type: owner.blood_type,
      relationship: params[:view_request][:relationship]
    )

    if @view_request.save
      flash[:notice] = '閲覧申請を送信しました。'
    else
      flash[:alert] = "申請に失敗しました: #{@view_request.errors.full_messages.join(', ')}"
    end

    redirect_to notes_path
  end

  def request_access
    viewer = current_user # B（閲覧申請者）

    # `parent_id` を整数として取得
    parent_id = params[:parent_id].to_i
    view_request = ViewRequest.find_by(user_id: viewer.id, parent_id: parent_id)

    unless view_request
      flash[:alert] = '閲覧申請情報が見つかりません。'
      return redirect_to notes_path
    end

    # `users` テーブルから A（公開者）を検索
    owner = User.find_by(id: view_request.parent_id)

    unless owner
      flash[:alert] = '指定された公開者が見つかりません。'
      return redirect_to notes_path
    end

    Rails.logger.debug "📌 照合された公開者 (Owner): #{owner.inspect}"

    # **① A（公開者）が B を閲覧許可に登録しているか確認**
    view_permission = ViewPermission.find_by(
      user_id: owner.id,
      first_name: viewer.first_name,
      first_name_furigana: viewer.first_name_furigana,
      last_name: viewer.last_name,
      last_name_furigana: viewer.last_name_furigana,
      birthday: viewer.birthday,
      blood_type: viewer.blood_type
    )

    if view_permission
      # **A（公開者）の UUID を使って公開ページ URL を取得**
      public_page_url = public_page_url(uuid: owner.uuid, custom_id: owner.id + 150_150)

      Rails.logger.debug "📌 取得した公開ページURL: #{public_page_url}"

      # **ViewAccess に保存**
      view_access = ViewAccess.find_or_initialize_by(viewer_id: viewer.id, owner_id: owner.id)
      view_access.update(
        public_page_url: public_page_url,
        access_count: (view_access.access_count || 0) + 1, # アクセス回数を増加
        last_accessed_at: Time.current
      )

      if view_access.save
        Rails.logger.debug "📌 保存された ViewAccess: #{view_access.inspect}"
        flash[:notice] = "#{owner.first_name} #{owner.last_name} さんの公開ページのURLを取得しました。"
      else
        flash[:alert] = "URL の保存に失敗しました: #{view_access.errors.full_messages.join(', ')}"
      end
    else
      flash[:alert] = '閲覧許可が登録されていません。'
    end

    redirect_to notes_path
  end

  private

  def view_request_params
    params.require(:view_request).permit(:relationship, :parent_id)
  end
end
