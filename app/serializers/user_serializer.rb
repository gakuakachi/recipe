# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :uuid, :name
end
