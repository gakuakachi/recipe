# frozen_string_literal: true

class RecipesController < ApplicationController
  before_action :authenticate
  before_action :set_recipe, only: %i[update destroy]
  before_action :set_measure_format_option, only: %i[index create update]
  def index
    unless Ingredient.valid_measure_format?(@measure_format)
      head :bad_request
      return
    end

    @recipes = Recipe.all.includes(:user, rates: [:user]).page(params[:page])
    render json: @recipes, root: 'recipes', adapter: :json, each_serializer: RecipeSerializer, measure_format: @measure_format,
           include: ['rates', 'rates.user', 'user'], status: :ok
  end

  def create
    @recipe = Recipe.new(recipe_params)
    if @recipe.save
      render json: @recipe, root: 'recipe', adapter: :json, serializer: RecipeSerializer,
             measure_format: @measure_format, include: ['rates', 'rates.user', 'user'], status: :created
    else
      head :bad_request
    end
  end

  def update
    @recipe.update!(recipe_params)
    render json: @recipe, root: 'recipe', adapter: :json, serializer: RecipeSerializer,
           measure_format: @measure_format, include: ['rates', 'rates.user', 'user'], status: :ok
  end

  def destroy
    @recipe.destroy!
    head :ok
  end

  private

  def set_recipe
    @recipe = Recipe.includes(:user, rates: [:user]).find_by(uuid: params[:id], user: current_user)
    return unless @recipe.blank?

    head :not_found
  end

  def set_measure_format_option
    @measure_format = params[:measure_format].presence || Ingredient::MEASURE_METRIC
  end

  def ingredients_params
    ingredients = params.require(:recipe).permit(ingredients: %i[name quantity unit])[:ingredients]
    ingredients.map do |ingredient|
      ingredient.merge(quantity: ingredient[:quantity].to_f)
    end
  end

  def recipe_params
    params.require(:recipe).permit(:description, steps: []).merge(user: current_user, ingredients: ingredients_params)
  end
end
