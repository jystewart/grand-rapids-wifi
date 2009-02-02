require File.dirname(__FILE__) + '/../test_helper'
require 'admin_controller'

# Re-raise errors caught by the controller.
class AdminController; def rescue_action(e) raise e end; end

class AdminControllerTest < Test::Unit::TestCase
  fixtures :users, :locations, :comments
  
  def setup
    @controller = AdminController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_login_required
    get :index
    assert_response :redirect
  end
  
  def test_login_works
    login_as :quentin
    get :index
    assert_response :success
  end
  
  def test_index
    login_as :quentin
    get :index
    assert_select 'a[href=/comments]', :text => 'Administer Comments'
    assert_select 'h3', :text => /Pending Locations/
    assert_select 'a[href=?]', /\/location\/view\/.*/, :count => 4
  end
end
