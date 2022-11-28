# frozen_string_literal: true

class RecipesController < ApplicationController
  before_action :authenticate
  before_action :set_measure_format_option, only: %i[index show create update]
  def index
    unless Ingredient.valid_measure_format?(@measure_format)
      head :bad_request
      return
    end

    render json: cache_recipes, status: :ok
  end

  def create
    @recipe = Recipe.new(recipe_params)
    if @recipe.save
      render json: @recipe, root: 'recipe', adapter: :json, serializer: RecipeSerializer,
             measure_format: @measure_format, include: ['rates', 'rates.user', 'user'], status: :created
    else
      render json: { errors: @recipe.errors.map(&:full_message) }, status: :bad_request
    end
  end

  def show
    @recipe = Recipe.includes(:user, rates: [:user]).find_by(uuid: params[:id], user: current_user)
    if @recipe.blank?
      head :not_found
    else
      render json: @recipe, root: 'recipe', adapter: :json, serializer: RecipeSerializer,
             measure_format: @measure_format, include: ['rates', 'rates.user', 'user'], status: :ok
    end
  end

  def update
    @recipe = Recipe.includes(:user, rates: [:user]).find_by(uuid: params[:id], user: current_user)
    if @recipe.blank?
      head :not_found
    else
      @recipe.update!(recipe_params)
      render json: @recipe, root: 'recipe', adapter: :json, serializer: RecipeSerializer,
             measure_format: @measure_format, include: ['rates', 'rates.user', 'user'], status: :ok
    end
  end

  def destroy
    @recipe = Recipe.find_by(uuid: params[:id], user: current_user)
    if @recipe.blank?
      head :not_found
    else
      @recipe.destroy!
      head :ok
    end
  end

  private

  def cache_recipes
    Rails.cache.fetch("cache_recipes_#{params[:page]}", expires_in: 1.minute) do
      recipes = Recipe.all.includes(:user, rates: [:user]).page(params[:page])
      render_to_string json: recipes,
                       root: 'recipes',
                       adapter: :json,
                       each_serializer: RecipeSerializer,
                       measure_format: @measure_format,
                       include: ['rates', 'rates.user', 'user']
    end
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
