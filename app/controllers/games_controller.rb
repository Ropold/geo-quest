class GamesController < ApplicationController
  before_action :set_game, only: [:show]

  def show
    @game = Game.find(params[:id])
  end

  def new_vs_p
    @game = Game.new
    @game.user_id = current_user.id
    @opponents = User.where.not(id: current_user.id).where.not(email: 'john@ai.com') # Alle Spieler außer der aktuelle Benutzer und die KI
  end

  def new_vs_ai
    @game = Game.new
    @game.user_id = current_user.id
    @game.status = "ongoing"
    @opponent = User.find_by(email: 'john@ai.com') # Fester Gegner für KI
  end

  def create_vs_ai
    @game = Game.new(game_params)
    @game.user_id = current_user.id
    @game.opponent_email = 'john@ai.com' # KI-Gegner

    if @game.save
      redirect_to @game, notice: 'Spiel gegen die KI wurde erstellt.'
    else
      flash.now[:alert] = 'Fehler beim Erstellen des Spiels. Bitte überprüfe deine Eingaben.'
      render :new_vs_ai
    end
  end

  def create_vs_p
    @game = Game.new(game_params)
    @game.user_id = current_user.id
    @game.opponent_email = params[:opponent_email] # E-Mail des gewählten Gegners

    if @game.save
      redirect_to @game, notice: 'Spiel gegen einen Spieler wurde erstellt.'
    else
      flash.now[:alert] = 'Fehler beim Erstellen des Spiels. Bitte überprüfe deine Eingaben.'
      render :new_vs_p
    end
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:deck_id) # Hier kannst du weitere Parameter hinzufügen, wenn nötig
  end
end
