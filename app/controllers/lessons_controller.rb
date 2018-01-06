class LessonsController < ApplicationController
  before_action :check_if_match_details, only: [:update]

  def index
    @lessons = Lesson.where({user_id: current_user.id}).all.map { |l| l }
  end

  def new
    @lesson = Lesson.new
  end

  def create
    Lesson.create_new_lesson(current_user,create_params)
    render :json => {result: 'ok'}
  end

  def show
    @lesson = Lesson.find(show_params[:id]) if show_params[:id].to_s != '-1'
  end

  def coaches_search
    query = search_params[:query].to_s
    @lesson = nil
    @lesson = Match.find(search_params[:lesson_id]) if show_params[:lesson_id].to_s != '-1'
    @selected_id ='-1'
    if(@lesson && @lesson.coach_id)
      @selected_id  = @lesson.coach_id.to_s
    end
    @search_results = User.where('name like ?',"%#{query}%")
    @search_results = @search_results.where.not(id: @lesson.coach_id) if @lesson
    @search_results = @search_results.pluck(:id,:name)
    render layout: false
  end

  private

  def create_params
    params.permit(:user_id,:coach_id,:coaches_notes,:lesson_date,:notes)
  end

  def show_params
    params.permit(:id)
  end
end
