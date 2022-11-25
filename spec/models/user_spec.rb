require 'rails_helper'

RSpec.describe User, type: :model do
  describe "self.authenticate?" do
    let!(:access_token) { "test_token" }
    context "when api key is not present" do
      it "returns false" do
        expect(User.authenticate?(access_token)).to eq false
      end
    end

    context "when api key is expired" do
      let!(:user) { FactoryBot.create(:user) }
      let!(:api_key) do
        api_key = FactoryBot.create(:api_key, user: user)
        api_key.update!(expires_at: DateTime.now - 1)
        api_key
      end
      it "returns false" do
        expect(User.authenticate?(api_key.access_token)).to eq false
      end
    end

    context "when api key is not active" do
      let!(:user) { FactoryBot.create(:user) }
      let!(:api_key) do
        api_key = FactoryBot.create(:api_key, user: user, active: false)
        api_key.update!(active: false)
        api_key
      end

      it "returns false" do
        expect(User.authenticate?(api_key.access_token)).to eq false        
      end
    end

    context "when api key is valid" do
      let!(:user) { FactoryBot.create(:user) }
      let!(:api_key) { FactoryBot.create(:api_key, user: user) }

      it "returns true" do
        expect(User.authenticate?(api_key.access_token)).to eq true
      end      
    end
  end

  describe "#activate!" do
    context "when api key is not present" do
      let!(:user) { FactoryBot.create(:user) }
      it "creates api key" do
        expect { user.activate! }.to change(ApiKey, :count).by(1)
      end
    end

    context "when api key is present" do
      let!(:user) { FactoryBot.create(:user) }
      let!(:api_key) { FactoryBot.create(:api_key, user: user) }
      it "returns api key" do
        expect { user.activate! }.to change(ApiKey, :count).by(0)
      end
    end

    context "when api key is expired" do
      let!(:user) { FactoryBot.create(:user) }
      let!(:api_key) do
        api_key = FactoryBot.create(:api_key, user: user)
        api_key.update!(expires_at: DateTime.now - 1)
        api_key
      end
      it "returns valid api key" do
        user.activate!
        api_key.reload
        expect(api_key.expired?).to eq false
      end      
    end

    context "when api key is not active" do
      let!(:user) { FactoryBot.create(:user) }
      let!(:api_key) do
        api_key = FactoryBot.create(:api_key, user: user)
        api_key.update!(active: false)
        api_key
      end
      it "returns active api key" do
        user.activate!
        api_key.reload
        expect(api_key.active?).to eq true
      end      
    end
  end
end
