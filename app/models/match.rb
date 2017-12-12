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
    if current_result.nil?
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

  def update_strengths(new_strengths)
    match_details = details
    match_details.strength_ids = new_strengths.map { |_id| _id.to_i }
    match_details.save!
  end

  def update_opponent(opponent_id)
    self.opponent_id = opponent_id.to_i
    self.save!
  end

  def update_location(location_id)
    self.court_id = location_id.to_i
    self.save!
  end

  def update_weaknesses(new_weaknesses)
    match_details = details
    match_details.weakness_ids = new_weaknesses.map { |_id| _id.to_i }
    match_details.save!
  end

  def update_note_to_self(new_note_to_self)
    match_details = details
    match_details.note_to_self = new_note_to_self
    match_details.save!
  end
end
