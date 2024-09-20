class AddPopulationDensityToDecks < ActiveRecord::Migration[7.1]
  def change
    add_column :decks, :population_density, :integer
  end
end
