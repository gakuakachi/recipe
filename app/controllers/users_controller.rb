# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    @user = User.new(create_params)
    if @user.save
      head :created
    else
      head :bad_request
    end
  end

  def create_params
    params
      .require(:user)
      .permit(:email, :name, :password, :password_confirmation)
  end
end
