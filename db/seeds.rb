# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user = User.create!(
  id: 1,
  name: 'Test 1',
  email: 'user1@test.com',
  password: 'test_user1_password',
  password_confirmation: 'test_user1_password'
)

5.times do |num|
  Recipe.create!(
    id: num + 1,
    user: user,
    description: "Recipe #{num + 1}",
    steps: ["Cook recipe #{num + 1}"],
    ingredients: [
      {
        'name' => "Ingredient #{num + 1}",
        'quantity' => num + 1,
        'unit' => 'g'
      }
    ]
  )
end

5.times do |num|
  Rate.create!(
    id: num + 1,
    user_id: user.id,
    recipe_id: num + 1,
    value: num + 1
  )
end
