require File.dirname(__FILE__) + '/../test_helper'

class VotesTest < Test::Unit::TestCase
  fixtures :votes

  def test_has_location
    vote = Vote.find(12)
    assert vote.location
    assert_equal Location, vote.location.class
    assert vote.location.votes.count > 0
  end
end
