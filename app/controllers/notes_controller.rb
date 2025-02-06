class NotesController < ApplicationController
  before_action :authenticate_user!

  def public_page
    @user = User.find_by(uuid: params[:uuid]) # UUID から公開者を取得
    @viewer = current_user # 閲覧者の情報
    @today = Date.today # 本日の日付

    return unless @user.nil?

    flash[:alert] = '指定された公開ページは存在しません。'
    redirect_to root_path
  end
end

def search_users
  @searched_users = User.where(
    last_name: params[:last_name],
    last_name_furigana: params[:last_name_furigana],
    first_name: params[:first_name],
    first_name_furigana: params[:first_name_furigana],
    birthday: params[:birthday],
    blood_type: params[:blood_type]
  )

  render :index
end

def request_access
  user = User.find(params[:user_id])
  if user
    flash[:notice] = "#{user.last_name} #{user.first_name} さんに閲覧申請を送りました"
  else
    flash[:alert] = 'ユーザーが見つかりませんでした'
  end
  redirect_to notes_path
end
