# == Schema Information
#
# Table name: courts
#
#  id              :integer          not null, primary key
#  name            :string
#  address         :text
#  longitude       :string
#  latitude        :string
#  summary         :string
#  google_map_link :string
#  phone           :string
#  indoor_courts   :integer
#  outdoor_courts  :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Court < ApplicationRecord
  has_many :matches
end
