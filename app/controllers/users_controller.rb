class UsersController < ApplicationController
  def search
    @users = User.where('email LIKE ? OR first_name LIKE ? OR last_name LIKE ?',
                        "%#{params[:search_query]}%", "%#{params[:search_query]}%", "%#{params[:search_query]}%")
    render json: @users
  end
end
