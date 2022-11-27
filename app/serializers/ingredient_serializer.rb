# frozen_string_literal: true

class IngredientSerializer < ActiveModel::Serializer
  attributes :name, :quantity, :unit

  def quantity
    object.quantity.round(1)
  end
end
