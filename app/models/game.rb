class Game < ApplicationRecord
  belongs_to :user
  belongs_to :deck
  belongs_to :opponent, class_name: 'User', foreign_key: 'opponent_id'
end
