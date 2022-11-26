require "rails_helper"

describe RatesController, type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:api_key) { FactoryBot.create(:api_key, user: user) }
  

  describe "POST recipes/:recipe_id/rates " do
    context "when rate is found" do
      let!(:recipe) { FactoryBot.create(:recipe, user: user) }
      let!(:rate) { FactoryBot.create(:rate, user: user, recipe: recipe) }
      it "does not create a rate" do
        params = {
          rate: {
            value: 1.1
          }
        }
        post "/recipes/" + recipe.uuid + "/rates", params: params, headers: headers(api_key)          
        expect(response.status).to eq 400
      end
    end

    context "when rate is not found" do
      let!(:recipe) { FactoryBot.create(:recipe, user: user) }
      context "when rate value is not valid" do
        it "does not create a rate" do
          params = {
            rate: {
              value: 5.1
            }
          }
          expect { post "/recipes/" + recipe.uuid + "/rates", params: params, headers: headers(api_key) }.to change(Rate, :count).by(0)
          expect(response.status).to eq 400  
        end
      end

      context "when rate value is valid" do
        it "creates a rate" do
          params = {
            rate: {
              value: 2.1
            }
          }
          expect { post "/recipes/" + recipe.uuid + "/rates", params: params, headers: headers(api_key) }.to change(Rate, :count).by(1)
          expect(response.status).to eq 201  
        end
      end
    end
  end

  describe "PUT recipes/:recipe_id/rates/:id " do
    context "when rate is not found" do
      let!(:recipe) { FactoryBot.create(:recipe, user: user) }
      it "does not update a rate" do
        params = {
          rate: {
            value: 1.1
          }
        }
        put "/recipes/" + recipe.uuid + "/rates/test-uuid", params: params, headers: headers(api_key)
        expect(response.status).to eq 404
      end
    end

    context "when recipe is not found" do
      it "does not update a rate" do
        params = {
          rate: {
            value: 1.1
          }
        }
        put "/recipes/test-uuid/rates/test-uuid", params: params, headers: headers(api_key)
        expect(response.status).to eq 404
      end
    end

    context "when rate and recipe are found" do
      let!(:recipe) { FactoryBot.create(:recipe, user: user) }
      let!(:rate) { FactoryBot.create(:rate, user: user, recipe: recipe) }
      it "does update a rate" do
        params = {
          rate: {
            value: 3.1
          }
        }
        put "/recipes/" + recipe.uuid + "/rates/" + rate.uuid, params: params, headers: headers(api_key)
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)["rate"]["value"]).to eq params[:rate][:value]
      end

    end
  end

  describe "DELTE recipes/:recipe_id/rates/:id" do
    context "when rate is not found" do
      let!(:recipe) { FactoryBot.create(:recipe, user: user) }
      it "does not delete a rate" do
        delete "/recipes/" + recipe.uuid + "/rates/test-uuid", headers: headers(api_key)
        expect(response.status).to eq 404
      end
    end

    context "when recipe is not found" do
      it "does not delete a rate" do
        delete "/recipes/test-uuid/rates/test-uuid", headers: headers(api_key)
        expect(response.status).to eq 404
      end
    end

    context "when rate and recipe are found" do
      let!(:recipe) { FactoryBot.create(:recipe, user: user) }
      let!(:rate) { FactoryBot.create(:rate, user: user, recipe: recipe) }
      it "does update a rate" do
        expect { delete "/recipes/" + recipe.uuid + "/rates/" + rate.uuid, headers: headers(api_key) }.to change(Rate, :count).by(-1)
        expect(response.status).to eq 200
      end
    end
  end
end
