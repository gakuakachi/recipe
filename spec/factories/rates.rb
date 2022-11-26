# frozen_string_literal: true

FactoryBot.define do
  factory :rate do
    association :recipe, factory: :recipe
    association :user, factory: :user
    value { rand(0.0..5.0) }
  end
end
