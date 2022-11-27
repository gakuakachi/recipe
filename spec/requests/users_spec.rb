# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /users' do
  context 'when valid params received' do
    it 'creates a user' do
      valid_params = {
        user: {
          email: Faker::Internet.email,
          name: Faker::Name.name,
          password: 'test_password',
          password_confirmation: 'test_password'
        }
      }

      expect { post '/users', params: valid_params }.to change(User, :count).by(1)
    end
  end

  context 'when invalid params received' do
    it 'does not create a user' do
      invalid_params = {
        user: {
          email: Faker::Internet.email,
          name: Faker::Name.name,
          password: 'test_password',
          password_confirmation: 'invalid_password'
        }
      }

      expect { post '/users', params: invalid_params }.to change(User, :count).by(0)
    end
  end
end
