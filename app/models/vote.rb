# == Schema Information
#
# Table name: votes
#
#  id          :integer(4)      not null, primary key
#  location_id :integer(2)
#  rating      :integer(1)
#  voter       :string(15)
#  created_at  :datetime        not null
#  aspect_id   :integer(4)
#

class Vote < ActiveRecord::Base
  belongs_to :location
  belongs_to :aspect

  validates_numericality_of :rating, :only_integer => true
  validates_presence_of :voter
  
  scope :listings, order('created_at DESC').includes(:location)
end
