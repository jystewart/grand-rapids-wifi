class Vote < ActiveRecord::Base
  belongs_to :location
  belongs_to :aspect

  validates_numericality_of :rating, :only_integer => true
  validates_presence_of :voter
end
