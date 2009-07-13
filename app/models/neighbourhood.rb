# == Schema Information
#
# Table name: neighbourhoods
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  permalink  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Neighbourhood < ActiveRecord::Base
  has_and_belongs_to_many :locations
  
  validates_presence_of :name, :permalink
  
  has_permalink :name
  
  def to_param
    self.permalink
  end
end
