class BrowserGamesController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: [:edit, :destroy, :update]
  
  def new
    @browser_game = current_user.browser_games.build
  end

  def edit
  end
  
  def update
    if @browser_game.update_attributes(parameters)
      redirect_to edit_browser_game_path(@browser_game)
    else
      render 'edit'
    end
  end

  def create
    @browser_game = current_user.browser_games.build(parameters)
    if @browser_game.save
      flash[:success] = "New game created"
      redirect_to edit_browser_game_path(@browser_game)
    else
      render 'new'
    end
  end

  def destroy
    @browser_game.destroy
    redirect_to user_url(current_user)
  end

  private

  def parameters
    params.require(:browser_game).permit(:name, :status, :amount_of_steps)
  end

  def correct_user
    @browser_game = current_user.browser_games.find_by(id: params[:id])
    redirect_to user_url(current_user) if @browser_game.nil?
  end
end
