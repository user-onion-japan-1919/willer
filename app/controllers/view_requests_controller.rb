class ViewRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    Rails.logger.debug "📌 Received Params: #{params.inspect}" # デバッグ用ログ

    # 生年月日を適切に組み立てる
    birthday = if params[:view_request]['birthday(1i)'].present? &&
                  params[:view_request]['birthday(2i)'].present? &&
                  params[:view_request]['birthday(3i)'].present?
                 Date.new(
                   params[:view_request]['birthday(1i)'].to_i,
                   params[:view_request]['birthday(2i)'].to_i,
                   params[:view_request]['birthday(3i)'].to_i
                 )
               else
                 nil
               end

    # 親ユーザー（閲覧対象者）を取得
    @parent = User.find_by(id: params[:view_request][:parent_id])
    unless @parent
      flash[:alert] = '親の情報が見つかりません。'
      return redirect_to notes_path
    end

    # 閲覧リクエストを作成
    @view_request = ViewRequest.new(view_request_params)
    @view_request.birthday = birthday
    @view_request.parent_id = @parent.id
    @view_request.user_id = current_user.id

    if @view_request.save
      flash[:notice] = '閲覧申請を送信しました。'
      redirect_to notes_path
    else
      flash[:alert] = "申請に失敗しました: #{@view_request.errors.full_messages.join(', ')}"
      redirect_to notes_path
    end
  end

  def request_access
    viewer = current_user # 閲覧申請者（A）
    target_user = User.find_by(id: params[:parent_id]) # 公開者（B）

    unless target_user
      flash[:alert] = '指定された公開者が見つかりません。'
      return redirect_to notes_path
    end

    # **① A（ログインユーザー）がB（公開者）を閲覧許可に登録しているか確認**
    view_permission = ViewPermission.find_by(
      user_id: target_user.id,
      first_name: viewer.first_name,
      first_name_furigana: viewer.first_name_furigana,
      last_name: viewer.last_name,
      last_name_furigana: viewer.last_name_furigana,
      birthday: viewer.birthday,
      blood_type: viewer.blood_type
    )

    # **② B（閲覧者）がAに閲覧申請を登録しているか確認**
    view_request = ViewRequest.find_by(
      user_id: viewer.id,
      parent_id: target_user.id,
      first_name: target_user.first_name,
      first_name_furigana: target_user.first_name_furigana,
      last_name: target_user.last_name,
      last_name_furigana: target_user.last_name_furigana,
      birthday: target_user.birthday,
      blood_type: target_user.blood_type
    )

    Rails.logger.debug "📌 閲覧許可: #{view_permission.inspect}, 閲覧申請: #{view_request.inspect}"

    if view_permission && view_request
      # **B（公開者）の公開ページURLを取得**
      public_page_url = public_page_url(uuid: target_user.uuid, custom_id: target_user.id + 150_150)

      Rails.logger.debug "📌 取得した公開ページURL: #{public_page_url}"

      # **ViewAccess に保存**
      view_access = ViewAccess.find_or_initialize_by(user_id: viewer.id, parent_id: target_user.id)
      view_access.public_page_url = public_page_url
      view_access.access_count = (view_access.access_count || 0) # 初回の場合は 0 にする
      view_access.last_accessed_at ||= Time.current

      if view_access.save
        Rails.logger.debug "📌 保存された ViewAccess: #{view_access.inspect}"
        flash[:notice] = "#{target_user.first_name} #{target_user.last_name} さんの公開ページのURLを取得しました。"
      else
        flash[:alert] = "URL の保存に失敗しました: #{view_access.errors.full_messages.join(', ')}"
      end
    else
      flash[:alert] = '閲覧許可と申請が一致しません。'
    end

    redirect_to notes_path
  end

  private

  def view_request_params
    params.require(:view_request).permit(
      :first_name, :first_name_furigana,
      :last_name, :last_name_furigana, :relationship,
      :blood_type, :parent_id, :birthday
    )
  end
end
