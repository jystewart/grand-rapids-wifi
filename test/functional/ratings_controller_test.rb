require File.dirname(__FILE__) + '/../test_helper'
require 'ratings_controller'

# Re-raise errors caught by the controller.
class RatingsController; def rescue_action(e) raise e end; end

class RatingsControllerTest < Test::Unit::TestCase
  def setup
    @controller = RatingsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_create_requires_referrer
    assert_no_difference "Vote.count" do
      post :create, :id => 'common-ground', :vote => {'rating' => 5 }
      assert_response 403
    end
  end
  
  def test_create_works
    @request.env['HTTP_REFERER'] = 'http://test.host/location/view/common-ground'
    assert_difference "Vote.count" do
      post :create, :id => 'common-ground', :vote => {'rating' => 5}
      assert_response :redirect
      assert_redirected_to :action => 'view', :id => 'common-ground'
    end
  end
end
