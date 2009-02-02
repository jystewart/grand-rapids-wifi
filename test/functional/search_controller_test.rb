require File.dirname(__FILE__) + '/../test_helper'
require 'search_controller'

# Re-raise errors caught by the controller.
class SearchController; def rescue_action(e) raise e end; end

class SearchControllerTest < Test::Unit::TestCase
  fixtures :locations, :openings
  
  def setup
    @controller = SearchController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_only_geocodes_when_appropriate
    get :results, :date => {"minute"=>"", "hour"=>"", "day"=>""}, 
      :location => { "zip"=>"", "free"=>"0", "address"=>"" }, 
      :keywords => ["bagel beanery"]
    assert_response :success
  end

  def test_now
    get :results, :open => 'now'
    assert_response :success
    assert_select "ul#hotspot-list" do
      assert_select "li", 0..80
    end
    assert_valid_markup
  end
  
  def test_results_for_zip_outside_location
    get :results, :zip => '49503'
    assert_select "ul#hotspot-list" do
      assert_select "li", :count => 20
    end    
  end
  
  def test_results_for_zip
    get :results, :location => { :zip => "49503" }
    assert_select "ul#hotspot-list" do
      assert_select "li", :count => 20
    end
  end
  
  def test_combined_search
    post :results, :location => { :zip => "49503" }, :keywords => 'downtown'
    assert_select "ul#hotspot-list" do
      assert_select "li", :count => 9
    end
    assert_valid_markup
  end
  
  def test_map_display
    post :results, :date => {:hour => '11', :minute => '03', :day => 'monday'}, :format => 'map'
    assert_response :success
  end
end
