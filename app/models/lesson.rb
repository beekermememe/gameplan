# == Schema Information
#
# Table name: lessons
#
#  id           :integer          not null, primary key
#  coach        :text
#  notes        :text
#  coach_id     :integer
#  lesson_date  :datetime
#  coaches_note :text
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Lesson < ApplicationRecord
  def self.create_new_lesson(current_user,create_params)
    Lesson.create({
      user_id: current_user.id,
      coach_id: create_params[:coach_id],
      lesson_date: create_params[:lesson_datetime],
      notes: create_params[:notes]
                  })
  end

  def coach
    coach_id ? User.find(coach_id) : nil
  end
end
