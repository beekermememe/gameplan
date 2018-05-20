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
    @gamemode = GameMode.find_by_user_id(@current_user.id) rescue GameMode.new(user_id: current_user.id)
    @gamemode.update!(update_params)
    @gamemode.save!
    render json: {status: 'ok'}
  end

  private
    def update_params
      params.permit(:enabled, :weaknesses, :strengths, :notes)
    end
end
