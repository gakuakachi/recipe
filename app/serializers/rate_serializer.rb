# frozen_string_literal: true

class RateSerializer < ActiveModel::Serializer
  attributes :uuid, :value
  belongs_to :user, serializer: UserSerializer
end
