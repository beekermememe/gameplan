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

  def opponent
    User.where(id: self.opponent_id).first
  end

  def court
    Court.where(id: self.court_id).first
  end

  def details
    MatchDetail.where(id: self.match_detail_id).first
  end

  def update_result(new_result)
    current_result = details.result
    if !current_result
      current_result = Result.new
      current_result.match_id = details.match_id
    end

    sets = []
    new_result.each do |set_score,count|
      sets << "#{set_score[:home]}-#{set_score[:away]}"
    end
    current_result.sets = sets
    current_result.save!

  end

end
