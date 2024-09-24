class DecksController < ApplicationController
  before_action :set_deck, only: [:show]

  def index
    if params[:query].present?
      # Verwende ein SQL-LIKE-Muster, um die Länderliste nach der Suchanfrage zu filtern
      @decks = Deck.where("country LIKE ?", "%#{params[:query]}%")
    else
      # Zeige alle Decks an, wenn keine Suchanfrage vorliegt
      @decks = Deck.all
    end
  end
  def show
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
