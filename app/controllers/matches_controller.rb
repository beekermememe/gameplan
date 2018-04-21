class MatchesController < ApplicationController
  before_action :check_if_match_details, only: [:update]

  def new
    @match = Match.new
    @match.match_detail = MatchDetail.new
  end

  def index
    @user = current_user
    @matches = current_user.matches
    if index_params[:created]
      flash[:notice] = "Welcome #{@user.name}, Time to Add Matches. Select the 'Add New Match' to Start"
    end
  end

  def create
    new_match = Match.create_new_match(current_user,create_params)
    render :json => {match_id: new_match ? new_match.id : nil}
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
      if show_params[:opponents2]
        @opponent = @match.opponent2
      else
        @opponent = @match.opponent
      end
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

  def post_match_notes
    @match = Match.find(show_params[:match_id])
    @post_match_notes = @match.match_detail ? @match.match_detail.post_match_notes : ""
    render layout: false
  end

  def league
    @match = Match.find(show_params[:match_id])
    @league = @match.league
    render layout: false
  end

  def season
    @match = Match.find(show_params[:match_id])
    @season = @match.season
    render layout: false
  end

  def team
    @match = Match.find(show_params[:match_id])
    @team = @match.team
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
    @search_results = @search_results.pluck(:id,:name, :city, :state)
    remote_results = UstaWebService.search_user(
        first_name: query.split(' ')[0],
        last_name: query.split(' ')[1],
        state: 'CO'
    )
    @search_results += remote_results
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
    if params[:opponent2]
      @match.update_opponent2(params[:opponent2])
    end
    if params[:location]
      @match.update_location(params[:location])
    end
    if params[:team]
      @match.update_team(params[:team])
    end
    if params[:season]
      @match.update_season(params[:season])
    end
    if params[:league]
      @match.update_league(params[:league])
    end
    if params[:post_match_notes]
      @match.update_post_match_notes(params[:post_match_notes])
    end
    if params[:match_datetime]
      @match.update_datetime(params[:match_datetime])
    end
    render json: {status: "ok"}
  end

  private

  def show_params
    params.permit(:id, :match_id, :opponents2)
  end

  def update_params
    params.permit(:id)
    params.require([:result,:strengths,:note_to_self,:opponent, :location, :notes_to_self, :match_datetime, :team, :season, :year, :post_match_notes])
  end

  def index_params
    params.permit(:created)
  end

  def search_params
    params.permit(:id, :match_id, :query)
  end

  def create_params
    params.permit(:result,:weakness_ids,:singles, :doubles, :strength_ids,:note_to_self,:opponent_id, :opponent2_id, :location_id, :post_match_notes, :notes_to_self, :match_datetime, :team, :season, :league)
  end

  private
  def check_if_match_details
    @match = Match.find(show_params[:id])
    unless @match.match_detail
      @match.match_detail = MatchDetail.create({match_id: @match.id})
    end
  end
end