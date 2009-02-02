require File.dirname(__FILE__) + '/../test_helper'
require 'location_controller'

# Re-raise errors caught by the controller.
class LocationController; def rescue_action(e) raise e end; end

class LocationControllerTest < Test::Unit::TestCase
  fixtures :users, :locations, :comments, :votes, :pings, :notifiables, :openings

  def setup
    @controller = LocationController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_list_locations
    login_as :quentin
    get :list
    assert_response :success
  end

  def test_index_works
    get :index
    assert_response :success
  end
  
  def test_should_be_able_to_get_rdf_for_locations
    get :index, :format => 'rdf'
    assert_response :success
  end
  
  def test_rss_request_should_redirect_to_atom
    get :index, :format => 'rss'
    assert_response :redirect
    assert_redirected_to locations_url(:format => 'atom')
  end

  def test_should_be_able_to_get_atom_for_locations
    get :index, :format => 'atom'
    assert_response :success
  end
  
  def test_should_be_able_to_get_atom_for_comments_on_location
    get :show, :id => 'common-ground', :format => 'atom'
    assert_response :success
  end
  
  def test_should_be_able_to_get_rdf_for_single_location
    get :show, :id => 'common-ground', :format => 'rdf'
    assert_response :success
  end
  
  def test_map_works
    get :index, :display => 'map'
    assert_response :redirect
    assert_redirected_to :action => 'map'
    follow_redirect
    assert_response :success
  end
  
  def test_redirects_numeric_id
    get :show, :id => 27
    assert_response :success
  end
  
  # Test all protected methods require login
  def test_should_require_login
    get :destroy, :id => 'common-ground'
    assert_response :redirect
    get :edit, :id => 'common-ground'
    assert_response :redirect
    get :create
    assert_response :redirect
  end
  
  def test_redirects_for_empty_location
    get :view
    assert_response :redirect
    assert_redirected_to :action => :index
  end
  
  def test_404_for_non_existent_location
    get :view, :id => 'my-fake-location'
    assert_response 404
  end
  
  def test_should_produce_list
    get :index
    assert_response :success
    assert_template 'location/index'
    assert_valid_markup
  end
  
  def test_should_require_post
    login_as :quentin
    get :destroy, :id => 'common-ground'
    assert_response :redirect
  end
  
  def test_edit_should_return_form
    login_as :quentin
    get :edit, :id => 'common-ground'
    assert_response :success
    assert_select 'form[action=/locations/common-ground][method=post]' do
      assert_select 'input[type=hidden][name=_method][value=put]'
    end
  end
  
  def test_create_should_return_form
    login_as :quentin
    get :create
    assert_response :success
    assert_select 'form[action=/locations][method=post]'
  end
  
  def test_should_display_location_with_comments_and_rating
    get :show, :id => 'common-ground'
    assert_response :success
    assert_select 'div#content' do
      assert_select 'h3:nth-of-type(2)', :text => /7.7778\/10 from 9 Ratings/
      assert_select 'div#comment-53[class=hreview]' do
        assert_select 'p[class=description]', :text => /a great relaxed atmosphere/
      end
    end
    assert_valid_markup
  end
  
  def test_create_should_work
    login_as :quentin
    assert_difference "Location.count" do
      post :create, :location => {:status => 'proven', :zip => 49503, :permalink => 'my-test-location', 
          :name => 'My Test Location', :street => 'Near My House'}
      assert_response :redirect
    end
  end
  
  def test_delete_should_work
    login_as :quentin
    assert_difference "Location.count", -1 do
      post :destroy, :id => 'common-ground'
      assert_response :redirect
    end
  end
  
  def test_update_should_work
    login_as :quentin
    updated = { :visibility => 'yes',
      :status => 'proven',
      :permalink => 'four-friends',
      :name => 'Four Friends Coffee House Part 2',
      :city => 'Grand Rapids',
      :zip => '49503',
      :updated_at => '2005-08-16 09:33:17 -04:00',
      :url => 'http://www.fourfriends.net',
      :phone_number => '',
      :ssid => 'FourFriends',
      :id => '27',
      :free => 'true',
      :description => 'A very popular community coffee house in the heart of downtown Grand Rapids. Draws a highly diverse range of customers, displays local art, and often hosts concerts and other entertainment in the evenings.',
      :street => '136 Monroe Center',
      :state => 'MI',
      :email => '4friends@fourfriends.net',
      :created_at => '2006-06-04 13:42:52 -04:00' }
    put :update, :id => 'four-friends', :location => updated
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 'four-friends'
  end
  
  def test_404_for_edit_bad_location
    login_as :quentin
    get :edit, :id => 'my-fake-location'
    assert_response 404
  end
  
  def test_404_for_delete_bad_location
    login_as :quentin
    post :destroy, :id => 'my-fake-location'
    assert_response 404
  end
  
  def test_creation_sends_pings
    assert_difference "Ping.count", Notifiable.count do
      login_as :quentin
      post :create, :location => {:status => "proven", :zip => 49503, :permalink => 'my-test-location', 
          :name => 'My Test Location', :street => 'Near My House', :visibility => 'yes'}
    end
  end
end
