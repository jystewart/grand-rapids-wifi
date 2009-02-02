class Neighbourhood < ActiveRecord::Base
  has_and_belongs_to_many :locations
  
  validates_presence_of :name, :permalink
  
  has_permalink :name
  
  def to_param
    self.permalink
  end
end
