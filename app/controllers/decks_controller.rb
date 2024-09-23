class DecksController < ApplicationController
  before_action :set_deck, only: [:show]

  def index
    # Zeigt alle Decks an, die über die API in die Datenbank eingefügt wurden
    @decks = Deck.all
  end

  def show
    # Zeigt Details eines einzelnen Decks an, inklusive der Karten im Deck
    @decks = Deck.find(params[:id])
  end

  private

  def set_deck
    @deck = Deck.find(params[:id])
  end

  def deck_params
    params.require(:deck).permit(:name, :description)
  end
  
end
