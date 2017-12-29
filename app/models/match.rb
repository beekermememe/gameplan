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

  def self.create_new_match(user,params)
    match = Match.create(
      user_id: user.id,
      court_id: params[:location_id].to_i,
      opponent_id: params[:opponent_id].to_i)

    result = Result.create(
      sets: params[:result].to_s == '' ? [] : params[:result].split(','),
      match_id: match.id
    )

    details = MatchDetail.create(
      strength_ids: params[:strength_ids].to_s == '' ? [] : params[:strength_ids].split(',').map {|i| i.to_i},
      weakness_ids: params[:weakness_ids].to_s == '' ? [] : params[:weakness_ids].split(',').map {|i| i.to_i},
      note_to_self: params[:note_to_self],
      result_id: result.id,
      match_id: match.id
    )
    match.match_detail_id = details.id
    match.save!
  end

  def opponent
    if self.opponent_id
      User.where(id: self.opponent_id).first
    else
      nil
    end
  end

  def court
    if self.court_id
      Court.where(id: self.court_id).first
    else
      nil
    end

  end

  def details
    if self.match_detail_id
      MatchDetail.where(id: self.match_detail_id).first
    else
      deets = MatchDetail.create(match_id: id)
      self.match_detail_id = deets.id
      self.save!
      deets
    end
  end

  def update_result(new_result)
    check_object
    current_result = result
    sets = []
    new_result.each do |set_score,count|
      sets << "#{set_score[:home]}-#{set_score[:away]}"
    end
    current_result.match_id = id
    current_result.sets = sets
    current_result.save!
    _match_details = match_detail
    match_detail.result_id = current_result.id
    _match_details.save!
  end

  def update_strengths(new_strengths)
    check_object
    _match_details = match_detail
    _match_details.match_id = id
    _match_details.strength_ids = new_strengths.map { |_id| _id.to_i }
    _match_details.save!
  end

  def update_opponent(opponent_id)
    self.opponent_id = opponent_id.to_i
    self.save!
  end

  def update_location(location_id)
    self.court_id = location_id.to_i
    self.save!
  end

  def update_datetime(new_date_time)
    self.court_id = location_id.to_i
    self.save!
  end

  def update_weaknesses(new_weaknesses)
    check_object
    _match_details = match_detail
    _match_details.match_id = id
    _match_details.weakness_ids = new_weaknesses.map { |_id| _id.to_i }
    _match_details.save!
  end

  def update_note_to_self(new_note_to_self)
    check_object
    _match_details = match_detail
    _match_details.match_id = id
    _match_details.note_to_self = new_note_to_self
    _match_details.save!
  end

  private
  def check_object
    unless match_detail_id
      deets = MatchDetail.create(match_id: id)
      self.match_detail_id = deets.id
      save!
    end

    if match_detail.result_id
      res = Result.create(match_id: id)
      deets = match_detail
      deets.result_id = res.id
      deets.save!
      save!
    end
  end
end
