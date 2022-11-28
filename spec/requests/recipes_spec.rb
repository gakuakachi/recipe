# frozen_string_literal: true

require 'rails_helper'

describe RecipesController, type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:api_key) { FactoryBot.create(:api_key, user: user) }

  describe 'GET /recipes' do
    let!(:recipes) do
      recipes = FactoryBot.create_list(:recipe, 3, user: user)
      recipes.map do |recipe|
        FactoryBot.create_list(:rate, 3, recipe: recipe)
      end
      recipes
    end

    context 'when measure format param is present' do
      context 'when measure format param is metric' do
        it 'success' do
          get '/recipes', headers: headers(api_key), params: { measure_format: 'metric' }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)['recipes'].size).to eq 3
        end
      end

      context 'when measure format param is imperial' do
        it 'success' do
          get '/recipes', headers: headers(api_key), params: { measure_format: 'imperial' }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)['recipes'].size).to eq 3
        end
      end

      context 'when measure format param is invalid' do
        it 'success' do
          get '/recipes', headers: headers(api_key), params: { measure_format: 'invalid' }
          expect(response.status).to eq 400
        end
      end
    end

    context 'when measure format param is blank' do
      it 'success' do
        get '/recipes', headers: headers(api_key)
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)['recipes'].size).to eq 3
      end
    end
  end

  describe 'GET /recipes/:id' do
    let!(:recipe) { FactoryBot.create(:recipe, user: user) }
    context 'when recipe is not found' do
      it 'does not return recipes' do
        get '/recipes/invalid_uuid', headers: headers(api_key)
        expect(response.status).to eq 404
      end
    end

    context 'when recipe is found' do
      it 'returns recipes' do
        get '/recipes/' + recipe.uuid, headers: headers(api_key)
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)['recipe']).to be_present
      end
    end
  end

  describe 'POST /recipes' do
    it 'creates a recipe' do
      # TODO: fix to handle with ingredients
      params = {
        recipe: {
          description: 'test recipe',
          steps: ['Cook'],
          ingredients: [{
            name: Faker::Food.spice,
            quantity: 10.0,
            unit: 'g'
          }]
        },
        measure_format: 'imperial'
      }
      expect { post '/recipes', params: params, headers: headers(api_key) }.to change(Recipe, :count).by(1)
      expect(response.status).to eq 201
    end
  end

  describe 'PUT /recipe/:id' do
    context 'when recipe is not found' do
      let!(:recipe) { FactoryBot.create(:recipe, user: FactoryBot.create(:user)) }
      let!(:ingredient_name) { Faker::Food.spice }
      it 'does not update a recipe' do
        params = {
          recipe: {
            description: 'test update recipe',
            steps: ['Cook'],
            ingredients: [{
              name: ingredient_name,
              quantity: 20,
              unit: 'g'
            }]
          }
        }
        put "/recipes/#{recipe.uuid}", params: params, headers: headers(api_key)
        expect(response.status).to eq 404
      end
    end
    context 'when recipe is found' do
      let!(:recipe) { FactoryBot.create(:recipe, user: user) }
      let!(:ingredient_name) { Faker::Food.spice }
      it 'updates a recipe' do
        params = {
          recipe: {
            description: 'test update recipe',
            steps: ['Grill'],
            ingredients: [{
              name: ingredient_name,
              quantity: 20,
              unit: 'g'
            }]
          }
        }
        put "/recipes/#{recipe.uuid}", params: params, headers: headers(api_key)
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)['recipe']['steps'].first).to eq 'Grill'
        expect(JSON.parse(response.body)['recipe']['ingredients'].first['name']).to eq ingredient_name
      end
    end
  end

  describe 'DELETE /recipe/:id' do
    let!(:recipe) { FactoryBot.create(:recipe, user: user) }
    it 'deletes a recipe' do
      expect { delete "/recipes/#{recipe.uuid}", headers: headers(api_key) }.to change(Recipe, :count).by(-1)
      expect(response.status).to eq 200
    end
  end
end
