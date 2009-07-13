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

require File.dirname(__FILE__) + '/../test_helper'

class OpeningTest < Test::Unit::TestCase
  fixtures :openings

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
