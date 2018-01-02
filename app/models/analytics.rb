class Analytics
  def loss_strengths(user_id)
    user_friendly_data = {}
    data = {}
    Match.all.each do |match|
      if(!match.result.win)
        match.match_detail.strength_ids.each do |strength_id|
          data[strength_id] ||= 0
          data[strength_id] += 1
        end
      end
    end
    data.each do |strength_id,count|
      Strength.find(strength_id)
      user_friendly_data[Strength.find(strength_id).title] = count
    end
    user_friendly_data
  end

  def record(user_id)
    data = {wins: 0,losses: 0}
    Match.all.each do |match|
      if(match.result.win)
        data[:wins] = data[:wins] + 1
      else
        data[:losses] = data[:losses] + 1
      end
    end
    data
  end
end