# frozen_string_literal: true

class ApiKey < ApplicationRecord
  belongs_to :user
  before_create :generate_access_token, :set_active, :set_expiration

  def expired?
    expires_at < DateTime.now
  end

  def set_active
    self.active = true
  end

  def set_expiration
    self.expires_at = DateTime.now + 1
  end

  private

  def generate_access_token
    loop do
      self.access_token = SecureRandom.hex
      break unless self.class.exists?(access_token: access_token)
    end
  end
end
