# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
Game.destroy_all
Deck.destroy_all
User.destroy_all

puts "Creating users..."

user1 = User.create!(email: "john@ai.com", password: "1234567898")
user2 = User.create!(email: "john@wick.com", password: "1234567898")
user3 = User.create!(email: "john@wayne.com", password: "1234567898")
user4 = User.create!(email: "john@lost.com", password: "1234567898")
user5 = User.create!(email: "john@montana.com", password: "1234567898")
user6 = User.create!(email: "john@brain.com", password: "1234567898")


puts "Creating decks..."
deck1 = Deck.create!(user: user1, country: "Germany", capital: "Berlin", inhabitants_of_the_capital: 300000, gross_domestic_product: 300, forest_area: 100, land_area: 357, road_network: 650, annual_temperature: 10.5, precipitation: 600, population_density: 230)
deck2 = Deck.create!(user: user2, country: "France", capital: "Paris", inhabitants_of_the_capital: 200000, gross_domestic_product: 200, forest_area: 200, land_area: 357, road_network: 650, annual_temperature: 10.5, precipitation: 600, population_density: 230)

puts "Creating games..."
game1 = Game.create!(user: user1, deck: deck1, status: "ongoing", points: 100)
