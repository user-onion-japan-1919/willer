class UsersController < ApplicationController
  before_action :authenticate_user!

  # ユーザー情報の更新
  def update
    if current_user.update(user_params)
      respond_to do |format|
        format.html { redirect_to user_path(current_user), notice: 'ユーザー情報を更新しました。' }
        format.json { render json: { status: 'success' }, status: :ok }
        format.js # JS形式のレスポンス
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: { status: 'error' }, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # ユーザー検索
  def search
    @users = User.all

    # 各項目が存在する場合のみ検索条件を追加
    @users = @users.where('last_name LIKE ?', "%#{params[:last_name]}%") if params[:last_name].present?
    @users = @users.where('last_name_furigana LIKE ?', "%#{params[:last_name_furigana]}%") if params[:last_name_furigana].present?
    @users = @users.where('first_name LIKE ?', "%#{params[:first_name]}%") if params[:first_name].present?
    if params[:first_name_furigana].present?
      @users = @users.where('first_name_furigana LIKE ?',
                            "%#{params[:first_name_furigana]}%")
    end

    # 生年月日の検索（パラメータキーを明示的に指定）
    if params['birthday(1i)'].present? && params['birthday(2i)'].present? && params['birthday(3i)'].present?
      birthday = Date.new(
        params['birthday(1i)'].to_i,
        params['birthday(2i)'].to_i,
        params['birthday(3i)'].to_i
      )
      @users = @users.where(birthday: birthday)
    end

    @users = @users.where(blood_type: params[:blood_type]) if params[:blood_type].present?
    @users = @users.where('phone_number LIKE ?', "%#{params[:phone_number]}%") if params[:phone_number].present?
    @users = @users.where('address LIKE ?', "%#{params[:address]}%") if params[:address].present?

    render json: @users
  end

  private

  # ユーザー情報の更新で許可するパラメータ
  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :first_name_furigana, :last_name_furigana, :birthday,
                                 :blood_type, :phone_number, :address, notes_attributes: [:id, :issue_1, :title_1, :content_1, :issue_2, :title_2, :content_2])
  end
end
