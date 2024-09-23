class GamesController < ApplicationController
  before_action :set_game, only: [:show, :play_round]

  def index
    @games = Game.all
  end

  def show
  end

  def new
    @game = Game.new
    @players = User.where.not(id: current_user.id) # Gegner auswählen
  end

  def new_vs_ai
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    @game.user_id = current_user.id
    @game.opponent_id = params[:opponent_id] # Gegner wird über Params gesetzt
    @game.status = "ongoing"
    @game.points = 0

    if current_user.decks.any?
      @game.deck = current_user.decks.first
    else
      redirect_to new_game_path, alert: 'Du hast kein verfügbares Deck.' and return
    end

    if @game.save
      distribute_cards(@game)
      redirect_to @game, notice: 'Spiel wurde erfolgreich erstellt und Karten wurden verteilt.'
    else
      flash.now[:alert] = 'Spiel konnte nicht erstellt werden. Bitte überprüfe die Eingaben.'
      render :new
    end
  end

  def create_vs_ai
    @game = Game.new(game_params)
    @game.user_id = current_user.id
    @game.opponent_id = User.find_by(email: 'ai@game.com').id # Fiktive KI-Benutzer
    @game.status = "ongoing"
    @game.points = 0

    if current_user.decks.any?
      @game.deck = current_user.decks.first
    else
      redirect_to new_vs_ai_game_path, alert: 'Du hast kein verfügbares Deck.' and return
    end

    if @game.save
      distribute_cards(@game)
      redirect_to @game, notice: 'Spiel gegen die KI wurde erfolgreich erstellt.'
    else
      flash.now[:alert] = 'Spiel gegen die KI konnte nicht erstellt werden.'
      render :new_vs_ai
    end
  end

  def play_round
    player1_card = @game.player_cards.find_by(user_id: @game.user_id)
    player2_card = @game.player_cards.find_by(user_id: @game.opponent_id)

    if player1_card && player2_card
      # Vergleiche die Karten
      if player1_card.deck.population_density > player2_card.deck.population_density
        # Spieler 1 gewinnt
        @game.increment!(:points, 1)
        player1_card.update(user_id: @game.user_id) # Karte zu Spieler 1 hinzufügen
      else
        # Spieler 2 gewinnt
        @game.increment!(:points, -1)
        player2_card.update(user_id: @game.opponent_id) # Karte zu Spieler 2 hinzufügen
      end

      # Entferne die gespielten Karten aus dem Spiel
      player1_card.destroy
      player2_card.destroy

      # Check if the game is over (e.g., no cards left)
      if @game.player_cards.count == 0
        @game.update(status: "completed")
        redirect_to @game, notice: 'Spiel beendet!' and return
      end
    else
      flash[:alert] = "Karten fehlen für eine der beiden Spieler."
    end

    redirect_to @game
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def distribute_cards(game)
    deck = Deck.find(game.deck_id)

    if deck.cards.any?
      cards = deck.cards.shuffle

      half_size = cards.size / 2
      player1_cards = cards[0...half_size]
      player2_cards = cards[half_size..-1]

      player1_cards.each do |card|
        game.player_cards.create(user_id: game.user_id, deck_id: card.id)
      end

      player2_cards.each do |card|
        game.player_cards.create(user_id: game.opponent_id, deck_id: card.id)
      end
    else
      Rails.logger.error "Das Deck hat keine Karten."
      flash[:alert] = "Das ausgewählte Deck hat keine Karten."
      redirect_to new_game_path and return
    end
  end

  def game_params
    params.require(:game).permit(:deck_id, :opponent_id)
  end
end
