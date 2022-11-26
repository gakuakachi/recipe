# frozen_string_literal: true

FactoryBot.define do
  factory :api_key do
    access_token { SecureRandom.hex }
    expires_at { DateTime.now + 1 }
  end
end
