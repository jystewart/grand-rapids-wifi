class Person < ActiveRecord::Base
  has_many :pets
  belongs_to :hobby
end
