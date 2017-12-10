class MatchesController < ApplicationController
  def show
    @match = Match.find(show_params[:id])
  end

  def result
    @match = Match.find(show_params[:match_id])
    @results = @match.match_detail.result
    render layout: false
  end

  def strengths
    @match = Match.find(show_params[:match_id])
    @all_strengths = Strength.all
    @current_strengths = @match.match_detail.strength_ids
    render layout: false
  end

  def weaknesses
    @match = Match.find(show_params[:match_id])
    @all_weaknesses = Weakness.all
    @current_weaknesses = @match.match_detail.weakness_ids
    render layout: false
  end

  def update
    @match = Match.find(params[:id])
    if params[:result]
      @match.update_result(params[:result].values)
    end
    render json: {status: "ok"}
  end

  private

  def show_params
    params.permit(:id, :match_id)
  end

  def update_params
    params.permit(:id)
    params.require(:result)
  end


end