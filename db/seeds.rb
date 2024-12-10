require 'faker'

puts "Cleaning up database..."
Favorite.destroy_all
Recipe.destroy_all
Search.destroy_all
User.destroy_all
puts "Database cleaned!"

user = User.create!(
  email: 'admin@matchmeal.eu',
  password: 'admin@matchmeal.eu',
  first_name: 'Match',
  last_name: 'Meal'
)

puts "Created user: #{user.email}"

3.times do
  Search.create!(
    meal_type: Faker::Food.dish,
    ingredients: Faker::Food.ingredient,
    user: user
  )
end

puts "Created 3 searches for the user"

searches = Search.all

5.times do
  Recipe.create!(
    name: Faker::Food.dish,
    description: Faker::Food.description,
    rating: rand(1..5),
    ingredients: Faker::Food.ingredient,
    cooking_time: rand(10..120),
    search_id: searches.sample.id,
    image: Faker::LoremFlickr.image(size: "300x300", search_terms: ['food'])
  )
end

puts "Created 5 recipes"

recipes = Recipe.all

2.times do
  Favorite.create!(
    user: user,
    recipe: recipes.sample
  )
end

puts "Created 2 favorites for the user"
