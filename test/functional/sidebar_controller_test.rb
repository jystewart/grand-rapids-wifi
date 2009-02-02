require File.dirname(__FILE__) + '/../test_helper'
require 'sidebar_controller'

# Re-raise errors caught by the controller.
class SidebarController; def rescue_action(e) raise e end; end

class SidebarControllerTest < Test::Unit::TestCase
  fixtures :locations, :comments

  def setup
    @controller = SidebarController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_highly_rated
    get :highly_rated
    assert_template 'sidebar/list'
    assert_select "div.sidebar" do
      assert_select "h3", "Most Highly Rated Hotspots"
      assert_select "a", :count => 5
    end
  end
  
  def test_least_comments
    get :least_comments
    assert_template 'sidebar/list'
    assert_select "div.sidebar" do
      assert_select "h3", "Hotspots In Need Of Comments"
      assert_select "a", :count => 5
    end
  end
  
  def test_most_comments
    get :most_comments
    assert_template 'sidebar/list'
    assert_select "div.sidebar" do
      assert_select "h3", "Most Commented On Hotspots"
      assert_select "a", :count => 5
    end
  end
  
  def test_recent_comments
    get :recent_comments
    assert_template 'sidebar/list'
    assert_select "div.sidebar" do
      assert_select "h3", "Recently Commented On"
      assert_select "a", :count => 5
    end
  end
end
