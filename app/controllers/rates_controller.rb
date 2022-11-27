# frozen_string_literal: true

class RatesController < ApplicationController
  before_action :authenticate
  before_action :set_recipe
  before_action :check_recipe
  before_action :set_rate, only: %i[update destroy]
  before_action :set_rate_by_recipe_and_user, only: [:create]
  before_action :check_rate, only: %i[update destroy]

  def create
    if @rate.present?
      head :bad_request
      return
    end

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
    @recipe = Recipe.find_by(uuid: params[:recipe_id], user: current_user)
  end

  def check_recipe
    return unless @recipe.blank?

    head :not_found
  end

  def set_rate
    @rate = Rate.find_by(uuid: params[:id], user: current_user)
  end

  def set_rate_by_recipe_and_user
    @rate = Rate.find_by(recipe: @recipe, user: current_user)
  end

  def check_rate
    return unless @rate.blank?

    head :not_found
  end

  def rate_params
    params.require(:rate).permit(:value).merge(recipe: @recipe, user: current_user)
  end
end
