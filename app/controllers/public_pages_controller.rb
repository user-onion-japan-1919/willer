class PublicPagesController < ApplicationController
  before_action :authenticate_user! # 閲覧にはログイン必須

  def show
    @user = User.find_by(uuid: params[:uuid]) # URLのUUIDから公開者(Aさん)を取得
    @viewer = current_user # 閲覧者(Bさん)
    @today = Date.today # 本日の日付

    return if @user

    flash[:alert] = '指定された公開ページは存在しません。'
    redirect_to root_path
  end
end
