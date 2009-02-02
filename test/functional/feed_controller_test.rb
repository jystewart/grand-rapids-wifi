require File.dirname(__FILE__) + '/../test_helper'
require 'feed_controller'

# Re-raise errors caught by the controller.
class FeedController; def rescue_action(e) raise e end; end

class FeedControllerTest < Test::Unit::TestCase
  fixtures :locations, :comments, :news

  def setup
    @controller = FeedController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_detection_rss
    get :index, :format => 'rss'
    assert_select "item"
  end
  
  def test_detection_atom
    get :index, :format => 'atom'
    assert_select 'feed>entry>content', :count => 30
  end
  
  def test_locations
    get :locations
    assert_response :redirect
    assert_redirected_to '/news.atom'
  end
  
  def test_news
    get :news
    assert_response :redirect
    assert_redirected_to '/news.atom'
  end
  
  def test_comments
    get :comments
    assert_select 'entry:nth-of-type(2) > id', :text => "http://test.host/news/google-maps-complete#comment265"
    assert_select 'updated', :text => /2006-09-10/
  end
  
  def test_index
    get :index, :format => 'atom'
    assert assigns(:entries)
    assert_equal 30, assigns(:entries).size

    assert_select 'feed[xmlns=http://www.w3.org/2005/Atom]' do
      assert_select 'updated', :text => /2006-09-10/
      assert_select 'entry:nth-of-type(6)' do
        assert_select 'id', :text => "http://test.host/locations/common-ground-1"
      end
      assert_select 'entry:nth-of-type(22)' do
        assert_select 'id', :text => "http://test.host/news/more-google-maps"
      end
      assert_select 'entry:nth-of-type(12)' do
        assert_select 'id', :text => "http://test.host/news/google-maps-complete#comment265"
      end
    end
  end
end
