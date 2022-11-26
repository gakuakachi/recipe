FactoryBot.define do
  factory :recipe do
    description {Faker::Food.dish}
    steps {["step"]}
    ingredients {["ingredient"]}
  end
end
