class DropPlayerCardsTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :player_cards
  end

  def down
    create_table :player_cards do |t|
      t.bigint :game_id, null: false
      t.bigint :user_id, null: false
      t.bigint :deck_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    add_index :player_cards, :deck_id
    add_index :player_cards, :game_id
    add_index :player_cards, :user_id

    add_foreign_key :player_cards, :decks
    add_foreign_key :player_cards, :games
    add_foreign_key :player_cards, :users
  end
end
