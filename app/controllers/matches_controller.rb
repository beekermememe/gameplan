class MatchesController < ApplicationController
  def show
    @match = Match.find(show_params[:id])
  end

  private

  def show_params
    params.permit(:id)
  end
end