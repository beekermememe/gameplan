class MatchesController < ApplicationController
  before_action :check_if_match_details, only: [:update]

  def new
    @match = Match.new
    @match.match_detail = MatchDetail.new
  end

  def create
    Match.create_new_match(current_user,create_params)
    render :json => {result: 'ok'}
  end

  def show
    @match = Match.find(show_params[:id]) if show_params[:id].to_s != '-1'
  end

  def search_opponent
    @match = Match.find(show_params[:id]) if show_params[:id].to_s != '-1'
  end

  def result
    if show_params[:match_id].to_s != '-1'
      @match = Match.find(show_params[:match_id])
      @results = @match.match_detail.result
    else
      @match = Match.new
      @match.match_detail = MatchDetail.new
      result = Result.new
      result.sets = []
      @results = result
    end
    render layout: false
  end

  def strengths
    @current_strengths = []
    if(show_params[:match_id].to_s != '-1')
      @match = Match.find(show_params[:match_id])
      @current_strengths = @match.match_detail ? @match.match_detail.strength_ids : []
    end
    @all_strengths = Strength.all
    render layout: false
  end

  def opponents
    if show_params[:match_id].to_s == '-1'
      @match = nil
      @opponent = nil
    else
      @match = Match.find(show_params[:match_id])
      @opponent = @match.opponent
    end

    render layout: false
  end

  def weaknesses
    @current_weaknesses = []
    if(show_params[:match_id].to_s != '-1')
      @match = Match.find(show_params[:match_id])
      @current_weaknesses = @match.match_detail ? @match.match_detail.weakness_ids : []
    end
    @all_weaknesses = Weakness.all
    render layout: false
  end

  def location
    if show_params[:match_id].to_s != '-1'
      @match = Match.find(show_params[:match_id])
      @location = @match.court
    end
    render layout: false
  end

  def note_to_self
    @match = Match.find(show_params[:match_id])

    @note_to_self = @match.match_detail ? @match.match_detail.note_to_self : ""
    render layout: false
  end

  def search_opponents
    query = search_params[:query].to_s
    @match = nil
    @match = Match.find(search_params[:match_id]) if show_params[:match_id].to_s != '-1'
    @selected_id ='-1'
    if(@match && @match.opponent_id)
      @selected_id  = @match.opponent_id.to_s
    end
    @search_results = User.where('name like ?',"%#{query}%")
    @search_results = @search_results.where.not(id: @match.user_id) if @match
    @search_results = @search_results.pluck(:id,:name)
    render layout: false
  end

  def search_locations
    @match = Match.find(search_params[:match_id]) if search_params[:match_id].to_s != '-1'
    query = search_params[:query].to_s
    @selected_id = (@match && @match.court_id) ? @match.court_id.to_s : '-1'
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
    if params[:match_datetime]
      @match.update_datetime(params[:match_datetime])
    end
    render json: {status: "ok"}
  end

  private

  def show_params
    params.permit(:id, :match_id)
  end

  def update_params
    params.permit(:id)
    params.require([:result,:strengths,:note_to_self,:opponent, :location, :notes_to_self, :match_datetime])
  end

  def search_params
    params.permit(:id, :match_id, :query)
  end

  def create_params
    params.permit(:result,:weakness_ids,:strength_ids,:note_to_self,:opponent_id, :location_id, :notes_to_self, :match_datetime)
  end

  private
  def check_if_match_details
    @match = Match.find(show_params[:id])
    unless @match.match_detail
      @match.match_detail = MatchDetail.create({match_id: @match.id})
    end
  end
end