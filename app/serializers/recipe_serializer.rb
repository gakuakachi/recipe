# frozen_string_literal: true

class RecipeSerializer < ActiveModel::Serializer
  attributes :uuid, :steps, :ingredients
  has_many :rates, serializer: RateSerializer
  belongs_to :user, serializer: UserSerializer
end
