class NoticeboardController < ApplicationController
  def index
    @user = current_user
    @upcoming_match = current_user.matches.where('match_datetime > ?',DateTime.now()).first
    @items_to_display = current_user.matches.where('match_datetime < ?',DateTime.now()).order('match_datetime desc').map { |match| match}
    @upcoming_lesson = current_user.lessons.where('lesson_date > ?',DateTime.now()).first
    @items_to_display += current_user.lessons.where('lesson_date < ?',DateTime.now()).order('lesson_date desc').map { |match| match}

    @items_to_display.sort! { |a,b|
      d1 = a.try(:match_datetime)
      d1 ||= a.try(:lesson_date)
      d2 = b.try(:match_datetime)
      d2 ||= b.try(:lesson_date)
      puts d1
      puts d2
      d2.to_i <=> d1.to_i
    }
   end
end