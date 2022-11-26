module AuthSupport
  def headers(api_key)
    { HTTP_AUTHORIZATION: "Token " + api_key.access_token }
  end
end