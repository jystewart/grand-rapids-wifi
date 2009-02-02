require File.dirname(__FILE__) + '/../test_helper'
require 'neighbourhoods_controller'

# Re-raise errors caught by the controller.
class NeighbourhoodsController; def rescue_action(e) raise e end; end

class NeighbourhoodsControllerTest < Test::Unit::TestCase
  fixtures :neighbourhoods

  def setup
    @controller = NeighbourhoodsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
