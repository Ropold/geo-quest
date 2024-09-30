class GamesController < ApplicationController
  before_action :set_game, only: [:show]

  # Zeigt ein Spiel an
  def show
    @game = Game.find(params[:id])
  end

  # Neues Spiel gegen einen menschlichen Spieler
  def new_vs_p
    @game = Game.new
    @game.user_id = current_user.id
    # Gegnerauswahl, alle Spieler außer der aktuelle Benutzer und die KI
    @opponents = User.where.not(id: current_user.id).where.not(email: 'john@ai.com')
  end

  # Neues Spiel gegen die KI
  def new_vs_ai
    @game = Game.new
    @game.user_id = current_user.id
    @game.status = 'ongoing'
    @opponent = User.find_by(email: 'john@ai.com') # Fester KI-Gegner
  end

  # Erstellen eines Spiels gegen die KI
  def create_vs_ai
    @game = Game.new(user_id: current_user.id, status: 'ongoing')
    @game.user_id = current_user.id
    @opponent = User.find_by(email: 'john@ai.com')
    @game.deck_id = current_user.decks.first.id if current_user.decks.any?

    Rails.logger.debug "Game attributes: #{@game.inspect}"# Finde den KI-Gegner

    if @opponent
      @game.opponent_id = @opponent.id # Setze den Gegner auf den KI-User (john@ai.com)

      if @game.save
        redirect_to @game, notice: 'Spiel gegen die KI wurde erfolgreich erstellt.' # Weiterleitung zur Spielansicht
      else
        flash.now[:alert] = 'Fehler beim Erstellen des Spiels.'
        render :new_vs_ai
      end
    else
      flash[:alert] = 'KI-Gegner wurde nicht gefunden.'
      render :new_vs_ai
    end
  end


  # Erstellen eines Spiels gegen einen menschlichen Spieler
  def create_vs_p
    @game = Game.new(game_params)
    @game.user_id = current_user.id
    @game.opponent_id = params[:game][:opponent_id]
    @game.deck_id = current_user.decks.first.id if current_user.decks.any? # ID des ausgewählten Gegners
    @game.status = 'ongoing'

    if @game.save
      redirect_to @game, notice: 'Spiel gegen einen Spieler wurde erstellt.'
    else
      flash.now[:alert] = 'Fehler beim Erstellen des Spiels. Bitte überprüfe deine Eingaben.'
      render :new_vs_p
    end
  end

  private

  # Spiel-Instanz setzen
  def set_game
    @game = Game.find(params[:id])
  end

  # Erlaubte Parameter für das Spiel
  def game_params
    params.require(:game).permit(:deck_id, :opponent_id) # opponent_id hinzugefügt
  end
end
