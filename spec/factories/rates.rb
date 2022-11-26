FactoryBot.define do
  factory :rate do
    association :recipe, factory: :recipe
    value { rand(0.0..5.0) }
  end
end
