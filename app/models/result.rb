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
    sets.each do |set|
      set_result = set.split("-")
      if set_result[0].to_i < set_result[1].to_i
        loss_count += 1
      else
        win_count += 1
      end
    end
    win_count > loss_count
  end

  def show_sets
    sets.join(' , ')
  end
end
