class Game < ApplicationRecord
  belongs_to :user
  has_many :decks
end
