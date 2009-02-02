require File.dirname(__FILE__) + '/../test_helper'
require 'welcome_controller'

# Re-raise errors caught by the controller.
class WelcomeController; def rescue_action(e) raise e end; end

class WelcomeControllerTest < Test::Unit::TestCase
  fixtures :locations, :news

  def setup
    @controller = WelcomeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_index_works
    get :index
    assert_response :success
    assert_template 'welcome/index'
    assert_valid_markup
  end
  
  def test_locations_included
    get :index
    assert_select "ul#locations" do
      assert_select "li.vcard", :count => 3
    end
  end
  
  def test_news_included
    get :index
    assert_select "ul#news" do
      assert_select "li.hentry", :count => 2
    end
  end
end
