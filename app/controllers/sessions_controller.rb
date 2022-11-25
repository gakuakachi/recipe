class SessionsController < ApplicationController
  def create

    @user = login(create_params[:email], create_params[:password])
    if @user
      api_key = @user.activate!
      render json: { access_token: api_key.access_token }, status: :created
    else
      head :not_found
    end
  end

  def create_params
    params.require(:session).permit(:email, :password)
  end

  private

  # the following method is not implemented in rails api so it is necessary to add the following method definition to make login method work
  # source: https://github.com/NoamB/sorcery/issues/724
  def form_authenticity_token; end
end
