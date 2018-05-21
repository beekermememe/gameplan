class GameMode < ApplicationRecord
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

  def update_weaknesses(new_weaknesses)
    check_object
    _match_details = match_detail
    _match_details.match_id = id
    _match_details.weakness_ids = new_weaknesses.map { |_id| _id.to_i }
    _match_details.save!
  end

  def update_note_to_self(new_note_to_self)
    self.note_to_self = new_note_to_self
    self.save!
  end

  def update_post_match_notes(post_match_notes)
    self.post_match_notes = post_match_notes
    self.save!
  end

  def update_strengths(new_strengths)
    self.strength_ids = new_strengths.map { |_id| _id.to_i }
    self.save!
  end

  def update_weaknesses(new_weaknesses)
    self.weakness_ids = new_weaknesses.map { |_id| _id.to_i }
    self.save!
  end
end
