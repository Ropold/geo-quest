class Deck < ApplicationRecord
  belongs_to :user

  include PgSearch::Model

  pg_search_scope :search_by_country,
                  against: :country,
                  using: {
                    tsearch: { prefix: true }, # Erlaubt die Suche mit Präfix
                    trigram: { threshold: 0.1 } # Trigramm-Ähnlichkeitssuche
                  }
end

