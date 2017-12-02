class MatchesController < ApplicationController
  def show
    @match = Match.find(show_params[:id])
  end

  def result
    @match = Match.find(show_params[:match_id])
    @results = @match.match_detail.result
    render layout: false
  end

  def update

  end

  private

  def show_params
    params.permit(:id, :match_id)
  end


end