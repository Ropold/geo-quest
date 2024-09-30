class AddOpponentIdToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :opponent_id, :bigint
    add_foreign_key :games, :users, column: :opponent_id
  end
end
