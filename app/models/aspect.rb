# == Schema Information
#
# Table name: aspects
#
#  id         :integer(4)      not null, primary key
#  name       :string(31)
#  created_at :datetime
#  updated_at :datetime
#

class Aspect < ActiveRecord::Base
end
