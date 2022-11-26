require "rails_helper"

describe RecipesController, type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:api_key) { FactoryBot.create(:api_key, user: user) }

  describe "GET /recipes" do
    before do
      recipes = FactoryBot.create_list(:recipe, 3, user: user)
      recipes.map do |recipe|
        FactoryBot.create_list(:rate, 3, recipe: recipe)
      end
    end
    it "success" do
      get "/recipes", headers: headers(api_key)
      expect(response.status).to eq 200
      expect(JSON.parse(response.body)["recipes"].size).to eq 3
    end
  end

  describe "POST /recipes" do
    it "creates a recipe" do
      #TODO fix to handle with ingredients
      params = {
        recipe: {
          description: "test recipe",
          steps: ["Add salt"],
          ingredients: [{
            name: "Salt",
            quantity: 10,
            unit: "gram"
          }]
        }
      }
      expect { post "/recipes", params: params, headers: headers(api_key) }.to change(Recipe, :count).by(1)
      expect(response.status).to eq 201
    end
  end
  
  describe "PUT /recipe/:id" do
    context "when recipe is not found" do
      let!(:recipe) { FactoryBot.create(:recipe, user: FactoryBot.create(:user)) }      
      it "does not update a recipe" do
        params = {
          recipe: {
            description: "test update recipe",
            steps: ["Add spice"],
            ingredients: [{
              name: "Spice",
              quantity: 20,
              unit: "gram"                
            }]
          }          
        }
        put "/recipes/" + recipe.uuid, params: params, headers: headers(api_key)
        expect(response.status).to eq 404
      end        
    end
    context "when recipe is found" do
      let!(:recipe) { FactoryBot.create(:recipe, user: user) }
      it "updates a recipe" do
        params = {
          recipe: {
            description: "test update recipe",
            steps: ["Add spice"],
            ingredients: [{
              name: "Spice",
              quantity: 20,
              unit: "gram"                
            }]
          }          
        }
        put "/recipes/" + recipe.uuid, params: params, headers: headers(api_key)
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)["recipe"]["steps"].first).to eq "Add spice"
        expect(JSON.parse(response.body)["recipe"]["ingredients"].first["name"]).to eq "Spice"
      end
    end
  end
  
  describe "DELETE /recipe/:id" do
    let!(:recipe) { FactoryBot.create(:recipe, user: user) }
    it "deletes a recipe" do
      expect { delete "/recipes/" + recipe.uuid, headers: headers(api_key) }.to change(Recipe, :count).by(-1)
      expect(response.status).to eq 200
    end
  end    
end
