require File.dirname(__FILE__) + '/../test_helper'
require 'about_controller'

# Re-raise errors caught by the controller.
class AboutController; def rescue_action(e) raise e end; end

class AboutControllerTest < Test::Unit::TestCase
  
  fixtures :locations

  def setup
    @controller = AboutController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_feeds
    get :feeds
    assert_response :success
    assert_template 'about/feeds'
    assert_valid_markup
  end
  
  def test_help
    get :help
    assert_response :success
    assert_template 'about/help'
    assert_valid_markup
  end
  
  def test_index
    get :index
    assert_response :success
    assert_template 'about/index'
    assert_valid_markup
  end  
  
  def test_links
    get :links
    assert_response :success
    assert_template 'about/links'
    assert_valid_markup
  end
end
