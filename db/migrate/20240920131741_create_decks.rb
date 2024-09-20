class CreateDecks < ActiveRecord::Migration[7.1]
  def change
    create_table :decks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :country
      t.text :capital
      t.integer :inhabitants_of_the_capital
      t.integer :gross_domestic_product
      t.integer :forest_area
      t.integer :land_area
      t.integer :road_network
      t.float :annual_temperature
      t.float :precipitation

      t.timestamps
    end
  end
end
