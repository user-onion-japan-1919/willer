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

    # 親ユーザーの取得
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
    viewer = current_user # 閲覧申請者（B）
    parent = User.find_by(id: params[:parent_id]) # 公開者（A）

    unless parent
      flash[:alert] = '指定された公開者が見つかりません。'
      return redirect_to notes_path
    end

    # **① A（公開者）がBを閲覧許可に登録しているか確認**
    view_permission = ViewPermission.find_by(
      user_id: parent.id,
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
      parent_id: parent.id,
      first_name: parent.first_name,
      first_name_furigana: parent.first_name_furigana,
      last_name: parent.last_name,
      last_name_furigana: parent.last_name_furigana,
      birthday: parent.birthday,
      blood_type: parent.blood_type
    )

    if view_permission && view_request
      flash[:notice] = "#{parent.first_name} #{parent.last_name} さんの公開ページのURLを取得しました。"
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
      :blood_type, :parent_id
    )
  end
end
