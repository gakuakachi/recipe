class User < ApplicationRecord
  authenticates_with_sorcery!
  
  has_many: :api_keys, dependent: :destroy
  has_many: :recipes, dependent: :destroy
  has_many: :rates, dependent: :destroy

  def authenticate?(access_token)
    api_key = ApiKey.find_by_access_token(access_token)
    return false if !api_key || !api_key.expired? || !api_key.active
    return !self.find(api_key.user_id).nil?
  end
end
