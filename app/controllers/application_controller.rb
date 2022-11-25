class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  private
  def authenticate
    authenticate_or_request_with_http_token do |token, _options|
      @_current_user ||= User.find_from_access_token(token)
      @_current_user.present?
    end
  end

  def current_user
    @_current_user
  end
end
