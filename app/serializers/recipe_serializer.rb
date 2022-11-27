# frozen_string_literal: true

class RecipeSerializer < ActiveModel::Serializer
  attributes :uuid, :steps, :ingredients
  has_many :rates, serializer: RateSerializer
  belongs_to :user, serializer: UserSerializer

  def ingredients
    object.ingredients.map do |ingredient_hash|
      ingredient = Ingredient.new(ingredient_hash['name'], ingredient_hash['quantity'], ingredient_hash['unit'])
      ingredient.convert_to_imperial if @instance_options[:measure_format] == Ingredient::MEASURE_IMPERIAL

      ingredient.serialize
    end
  end
end
