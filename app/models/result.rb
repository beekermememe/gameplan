# == Schema Information
#
# Table name: results
#
#  id         :integer          not null, primary key
#  sets       :string           default([]), is an Array
#  match_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Result < ApplicationRecord
  belongs_to :match
  def win
    win_count = 0
    loss_count = 0
    if sets.count > 0
      sets.each do |set|
        set_result = set.split("-")
        if set_result[0].to_i < set_result[1].to_i
          loss_count += 1
        else
          win_count += 1
        end
      end
      win_count > loss_count
    else
      nil
    end
  end

  def is_match_in_the_future
    match = Match.find(match_id)
    match.match_datetime &&  match.match_datetime > Time.now
  end

  def summary
    win_count = 0
    loss_count = 0
    if sets.count > 0
      sets.each do |set|
        set_result = set.split("-")
        if set_result[0].to_i < set_result[1].to_i
          loss_count += 1
        else
          win_count += 1
        end
      end
      if win_count > loss_count
        "Win"
      else
        "Loss"
      end
    elsif is_match_in_the_future
      "Upcoming"
    else
      "Please add result"
    end
  end

  def show_sets
    sets.join(' , ')
  end
end
