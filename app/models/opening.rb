# == Schema Information
#
# Table name: openings
#
#  id           :integer(4)      not null, primary key
#  location_id  :integer(4)
#  opening_day  :integer(4)
#  closing_day  :integer(4)
#  opening_time :time
#  closing_time :time
#

class Opening < ActiveRecord::Base
  belongs_to :location
  validates_presence_of :opening_day, :opening_time, :closing_day, :closing_time
  validates_inclusion_of :opening_day, :in => 1..7
  validates_inclusion_of :closing_day, :in => 1..7
  
  def opening_day_name
    %w(monday tuesday wednesday thursday friday saturday sunday)[self.opening_day - 1]
  end
  
  def closing_day_name
    %w(monday tuesday wednesday thursday friday saturday sunday)[self.closing_day - 1]
  end
end
