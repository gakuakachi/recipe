class RecipesController < ApplicationController
  before_action :authenticate
  before_action :set_recipe, only: [:update, :destroy]
  def index
    @recipes = Recipe.all
    render json: { recipes: @recipes }, status: :ok
  end

  def create
    @recipe = Recipe.new(create_params.to_h)
    if @recipe.save
      render json: { recipe: @recipe }, status: :created
    else
      head :bad_request
    end
  end

  def update
    @recipe.update!(update_params)
    render json: { recipe: @recipe }, status: :ok
  end

  def destroy
    @recipe.destroy!
    head :ok
  end
  
  private

  def set_recipe
    @recipe = Recipe.where(uuid: params[:id], user: current_user).take
    if @recipe.blank?
      head :not_found
    end
  end

  def create_params
    params.require(:recipe).permit(:description, steps: [], ingredients: [:name, :quantity, :unit]).merge(user: current_user)
  end

  def update_params
    params.require(:recipe).permit(:description, steps: [], ingredients: [:name, :quantity, :unit])
  end
end