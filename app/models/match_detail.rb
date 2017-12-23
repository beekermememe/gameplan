# == Schema Information
#
# Table name: match_details
#
#  id           :integer          not null, primary key
#  strengths    :string           default([]), is an Array
#  strength_ids :string           default([]), is an Array
#  weaknesses   :string           default([]), is an Array
#  weakness_ids :string           default([]), is an Array
#  result_id    :integer
#  details      :text
#  note_to_self :text
#  played_date  :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class MatchDetail < ApplicationRecord
  belongs_to :match

  def result
    self.result_id ? Result.find(self.result_id) : Result.new
  end

  def show_strengths
    if strength_ids
      _strengths = Strength.where(id: strength_ids.map { |_id| _id.to_i})
      _strengths.map { |s| s.title }.join(', ')
    else
      ''
    end

  end

  def show_weaknesses
    if weakness_ids
      _weaknesses = Weakness.where(id: weakness_ids.map { |_id| _id.to_i})
      _weaknesses.map { |s| s.title }.join(', ')
    else
      ''
    end
  end

end
