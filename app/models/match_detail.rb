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

end
