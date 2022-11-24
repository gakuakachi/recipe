class ApplicationController < ActionController::API
  private
  def authenticate
    authenticate_or_request_with_http_token do |token, _options|
      User.authenticate?(token)
    end
  end
end
