# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /sessions' do
  context 'when user is found' do
    let(:password) { SecureRandom.hex }
    let(:user) { FactoryBot.create(:user, password: password, password_confirmation: password) }
    it 'creates an api key' do
      params = {
        session: {
          email: user.email,
          password: password
        }
      }
      expect { post '/sessions', params: params }.to change(ApiKey, :count).by(1)
    end
  end

  context 'when user is not found' do
    it 'does not create an api key' do
      params = {
        session: {
          email: 'dummy',
          password: 'dummy'
        }
      }
      expect { post '/sessions', params: params }.to change(ApiKey, :count).by(0)
    end
  end
end
