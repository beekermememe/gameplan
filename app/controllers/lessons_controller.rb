class LessonsController < ApplicationController

  def index
    @lessons = Lesson.where({user_id: current_user.id}).all.map { |l| l }
  end

  def update
    @lesson = Lesson.find(params[:id])
    @lesson.update(update_params)
    render json: {status: 'ok'}
  end

  def player_notes
    @lesson = Lesson.find(search_params[:lesson_id]) if search_params[:lesson_id].to_s != '-1'
    @notes = @lesson.notes
    render layout: false
  end

  def new
    @lesson = Lesson.new
  end

  def create
    new_lesson = Lesson.create_new_lesson(current_user,create_params)
    render :json => {lesson_id: new_lesson ? new_lesson.id : nil}
  end

  def show
    @lesson = Lesson.find(show_params[:id]) if show_params[:id].to_s != '-1'
  end

  def coaches
    @lesson = nil
    @lesson = Lesson.find(search_params[:lesson_id]) if search_params[:lesson_id].to_s != '-1'
    @coach = @lesson ? @lesson.coach : nil
    render layout: false
  end
  def coaches_search
    query = search_params[:query].to_s
    @lesson = nil
    @lesson = Lesson.find(search_params[:lesson_id]) if search_params[:lesson_id].to_s != '-1'
    @selected_id ='-1'
    if(@lesson && @lesson.coach_id)
      @selected_id  = @lesson.coach_id.to_s
    end
    @search_results = User.where('name like ?',"%#{query}%")
    @search_results = @search_results.where.not(id: @lesson.user_id) if @lesson
    @search_results = @search_results.pluck(:id,:name, :city, :state)
    remote_results = UstaWebService.search_user(
        first_name: query.split(' ')[0],
        last_name: query.split(' ')[1],
        state: 'CO'
    )
    @search_results += remote_results
    render layout: false
  end

  private

  def update_params
    params.permit(:coach_id,:coaches_notes,:lesson_date,:notes)
  end

  def create_params
    params.permit(:user_id,:coach_id,:coaches_notes,:lesson_datetime,:notes)
  end

  def search_params
    params.permit(:query, :lesson_id)
  end

  def show_params
    params.permit(:id)
  end
end
