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

require File.dirname(__FILE__) + '/../test_helper'

class NeighbourhoodTest < Test::Unit::TestCase
  fixtures :neighbourhoods

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
