class RemoveGameFromDecks < ActiveRecord::Migration[7.1]
  def change
    remove_reference :decks, :game, null: false, foreign_key: true
  end
end
