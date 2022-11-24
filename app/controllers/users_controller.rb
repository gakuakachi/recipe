class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      head :created
    else
      head :bad_request
      
  end

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end
