class MatchesController < ApplicationController

  def new
    @match = Match.new
    @match.match_detail = MatchDetail.new
  end

  def create

  end

  def show
    @match = Match.find(show_params[:id])
  end

  def search_opponent
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

  def opponents
    @match = Match.find(show_params[:match_id])
    @opponent = @match.opponent
    render layout: false
  end

  def weaknesses
    @match = Match.find(show_params[:match_id])
    @all_weaknesses = Weakness.all
    @current_weaknesses = @match.match_detail.weakness_ids
    render layout: false
  end

  def location
    @match = Match.find(show_params[:match_id])
    @location = @match.court
    render layout: false
  end

  def note_to_self
    @match = Match.find(show_params[:match_id])
    @note_to_self = @match.match_detail.note_to_self
    render layout: false
  end

  def search_opponents
    @match = Match.find(search_params[:match_id])
    query = search_params[:query].to_s
    @selected_id = @match.opponent_id ? @match.opponent_id.to_s : '-1'
    @search_results = User.where('name like ?',"%#{query}%").where.not(id: @match.user_id).pluck(:id,:name)
    render layout: false
  end

  def search_locations
    @match = Match.find(search_params[:match_id])
    query = search_params[:query].to_s
    @selected_id = @match.court_id ? @match.court_id.to_s : '-1'
    @search_results = Court.where('name like ?',"%#{query}%").pluck(:id,:name, :address)
    render layout: false
  end

  def update
    @match = Match.find(params[:id])
    if params[:result]
      @match.update_result(params[:result].values)
    end
    if params[:strengths]
      @match.update_strengths(params[:strengths])
    end
    if params[:weaknesses]
      @match.update_weaknesses(params[:weaknesses])
    end
    if params[:note_to_self]
      @match.update_note_to_self(params[:note_to_self])
    end
    if params[:opponent]
      @match.update_opponent(params[:opponent])
    end
    if params[:location]
      @match.update_location(params[:location])
    end
    render json: {status: "ok"}
  end

  private

  def show_params
    params.permit(:id, :match_id)
  end

  def update_params
    params.permit(:id)
    params.require([:result,:strengths,:note_to_self,:opponent])
  end

  def search_params
    params.permit(:id, :match_id, :query)
  end

end