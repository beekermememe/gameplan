class GameModesController < ApplicationController

  def show
    @match = Match.new
    @match.match_detail = MatchDetail.new
    @gamemode = GameMode.find_by_user_id(current_user.id) rescue GameMode.new
    @gamemode.save
  end

  def enable
    @gamemode = GameMode.find_by_user_id(current_user.id) rescue GameMode.new
    @gamemode.enabled = true
    @gamemode.save!
    render json: {status: 'ok'}
  end

  def disable
    @gamemode = GameMode.find_by_user_id(current_user.id) rescue GameMode.new(user_id: current_user.id)
    @gamemode.enabled = false
    @gamemode.save!
    render json: {status: 'ok'}
  end

  def update
    @gamemode = GameMode.find_by_user_id(current_user.id)
    if params[:strengths]
      @gamemode.update_strengths(params[:strengths])
    end
    if params[:weaknesses]
      @gamemode.update_weaknesses(params[:weaknesses])
    end
    if params[:note_to_self]
      @gamemode.update_note_to_self(params[:note_to_self])
    end
    if params[:post_match_notes]
      @gamemode.update_post_match_notes(params[:post_match_notes])
    end
    render json: {status: 'ok'}
  end

  def strengths
    @gamemode = GameMode.find_by_user_id(@current_user.id) rescue GameMode.new(user_id: current_user.id)
    @current_strengths = @gamemode.strength_ids
    @all_strengths = Strength.all
    render layout: false
  end

  def weaknesses
    @gamemode = GameMode.find_by_user_id(@current_user.id) rescue GameMode.new(user_id: current_user.id)
    @current_weaknesses = @gamemode.weakness_ids
    @all_weaknesses = Weakness.all
    render layout: false
  end

  def post_match_notes
    @gamemode = GameMode.find_by_user_id(@current_user.id) rescue GameMode.new(user_id: current_user.id)
    render layout: false

  end

  def note_to_self
    @gamemode = GameMode.find_by_user_id(@current_user.id) rescue GameMode.new(user_id: current_user.id)
    render layout: false
  end

  private
    def update_params
      params.permit(:enabled, :weaknesses, :strengths, :notes, :note_to_self, :post_match_notes)
    end
end
