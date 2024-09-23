class CreatePlayerCards < ActiveRecord::Migration[7.1]
  def change
    create_table :player_cards do |t|
      t.references :game, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :deck, null: false, foreign_key: true

      t.timestamps
    end
  end
end
