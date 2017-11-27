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
    Result.find(self.result_id)
  end

  def show_strengths
    _strengths = Strength.where(id: strength_ids)
    _strengths.map { |s| s.title }.join(', ')
  end

  def show_weaknesses
    _weaknesses = Weakness.where(id: weakness_ids)
    _weaknesses.map { |s| s.title }.join(', ')
  end

end
