# == Schema Information
#
# Table name: tennis_dictionaries
#
#  id              :integer          not null, primary key
#  title           :string
#  lowercase_title :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class TennisDictionary < ApplicationRecord
end
