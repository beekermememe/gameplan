# == Schema Information
#
# Table name: matches
#
#  id               :integer          not null, primary key
#  court_id         :integer
#  court_number     :integer
#  user_id          :integer
#  opponent_id      :integer
#  match_detail_id  :integer
#  match_datetime   :datetime
#  timezone         :integer
#  league_id        :integer
#  result_summary   :text
#  location_summary :text
#  opponent_summary :text
#  doubles          :boolean
#  singles          :boolean
#  partner_id       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Match < ApplicationRecord
  has_one :result
  has_one :match_detail
  has_one :court
end
