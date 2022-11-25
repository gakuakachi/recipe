class User < ApplicationRecord
  include UuidAutoGenerate
  authenticates_with_sorcery!
  before_create :generate_uuid
  
  has_many :api_keys, dependent: :destroy
  has_many :recipes, dependent: :destroy
  has_many :rates, dependent: :destroy

  validates :password, length: { minimum: 3 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  def self.find_from_access_token(access_token)
    api_key = ApiKey.find_by_access_token(access_token)
    return if !api_key || api_key.expired? || !api_key.active
    return self.find(api_key.user_id)
  end

  def activate!
    return ApiKey.create!(user_id: self.id) if !api_key

    if !api_key.active || api_key.expired?
      api_key.set_active
      api_key.set_expiration
      api_key.save!
    end

    return api_key
  end

  def deactivate!
    api_key.active = false
    api_key.save!
  end

  private

  def api_key
    @api_key ||= ApiKey.find_by_user_id(self.id)
  end
end
