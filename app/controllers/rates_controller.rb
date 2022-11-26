class RatesController < ApplicationController
  before_action :authenticate
  before_action :set_recipe
  before_action :set_rate, only: [:update, :destroy]
  before_action :set_rate_by_recipe_and_user, only: [:create]
  before_action :rate?, only: [:update, :destroy]

  def create
    @rate = Rate.new(rate_params)
    if @rate.save
      render json: { rate: @rate }, status: :created
    else
      head :bad_request
    end
  end

  def update
    @rate.update!(rate_params)
    render json: { rate: @rate }, status: :ok
  end

  def destroy
    @rate.destroy!
    head :ok
  end

  private

  def set_recipe
    @recipe = Recipe.where(uuid: params[:recipe_id], user: current_user).take
    if @recipe.blank?
      head :not_found
    end
  end

  def set_rate
    @rate = Rate.where(uuid: params[:id], user: current_user).take
  end

  def set_rate_by_recipe_and_user
    @rate = Rate.where(recipe: @recipe, user: current_user).take
    if @rate.present?
      head :bad_request
    end
  end

  def rate?
    if @rate.blank?
      head :not_found
    end
  end

  def rate_params
    params.require(:rate).permit(:value).merge(recipe: @recipe, user: current_user)
  end
end
