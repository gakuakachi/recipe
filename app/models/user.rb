# frozen_string_literal: true

class User < ApplicationRecord
  include UuidAutoGenerate
  authenticates_with_sorcery!
  before_create :generate_uuid

  has_many :api_keys, dependent: :destroy
  has_many :recipes, dependent: :destroy
  has_many :rates, dependent: :destroy

  validates :password, length: { minimum: 10 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  def self.find_from_access_token(access_token)
    api_key = ApiKey.find_by_access_token(access_token)
    return if api_key.blank? || api_key.expired? || !api_key.active

    find(api_key.user_id)
  end

  def activate!
    return ApiKey.create!(user_id: id) unless api_key

    if !api_key.active || api_key.expired?
      api_key.set_active
      api_key.set_expiration
      api_key.save!
    end

    api_key
  end

  private

  def api_key
    @api_key ||= ApiKey.find_by_user_id(id)
  end
end
