# == Schema Information
#
# Table name: notifiables
#
#  id       :integer(4)      not null, primary key
#  name     :string(255)
#  endpoint :string(255)
#

require File.dirname(__FILE__) + '/../test_helper'

class NotifiableTest < Test::Unit::TestCase
  fixtures :notifiables

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
