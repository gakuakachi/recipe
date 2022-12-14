# frozen_string_literal: true

FactoryBot.define do
  factory :recipe do
    description { Faker::Food.dish }
    steps { ['step'] }
    ingredients { [{ name: Faker::Food.spice, quantity: rand(0.1..100.0), unit: 'g' }] }
  end
end
