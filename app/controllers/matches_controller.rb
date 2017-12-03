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