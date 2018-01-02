class LessonsController < ApplicationController
  before_action :check_if_match_details, only: [:update]

  def index
    Lesson.where({user_id: current_user.id}).all.map { |l| l }
  end

  def new
    @lesson = Lesson.new
    @match.match_detail = MatchDetail.new
  end

  def create
    Lesson.create_new_lesson(current_user,create_params)
    render :json => {result: 'ok'}
  end

  def show
    @lesson = Lesson.find(show_params[:id]) if show_params[:id].to_s != '-1'
  end

  private

  def create_params
    params.permit(:user_id,:coach_id,:coaches_notes,:lesson_date,:notes)
  end

  def show_params
    params.permit(:id)
  end
end
