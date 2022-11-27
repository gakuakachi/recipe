# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  describe 'self.create' do
    it 'create api key with expected parameters' do
      user = FactoryBot.create(:user)
      api_key = ApiKey.new(user: user)
      expect(api_key.save).to eq true
      expect(api_key.active).to eq true
      expect(api_key.expires_at).to be > DateTime.now
    end
  end
end
