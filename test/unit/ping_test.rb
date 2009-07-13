# == Schema Information
#
# Table name: pings
#
#  id            :integer(4)      not null, primary key
#  pingable_id   :integer(4)
#  pingable_type :string(255)
#  created_at    :datetime
#  notifiable_id :integer(4)
#

require File.dirname(__FILE__) + '/../test_helper'

class PingTest < Test::Unit::TestCase
  fixtures :pings

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
