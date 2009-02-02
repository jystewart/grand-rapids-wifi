require "#{File.dirname(__FILE__)}/../test_helper"

class LegacyTest < ActionController::IntegrationTest
  fixtures :locations, :news, :users

  def test_pre_rest_locations
    get "/location"
    # assert_response 301
    # follow_redirect!
    assert_response :success
        
    l = Location.find(:first)
    assert_permanently_redirected "/location/view/#{l.permalink}"
  end
  
  def test_numeric_locations
    assert_permanently_redirected "/location/92.atom", "/locations/buffalo-ww-celebration?format=atom"
    assert_permanently_redirected "/locations/92.atom", "/locations/buffalo-ww-celebration?format=atom"
  end
  
  def test_pre_rest_news
    n = News.find(:first)
    assert_permanently_redirected "/news/story/#{n.permalink}"
  end
  
  def test_comments_rss_redirected
    get "/feeds/comments.rss"
    assert_response :success
  end

  def test_pre_rest_location_feed
    assert_permanently_redirected "/location/view/urban-mill-downtown.rss", 
      "/locations/urban-mill-downtown?format=atom"
  end
  
  def test_location_rss_redirected_to_atom
    assert_permanently_redirected "/locations/urban-mill-downtown.rss", 
      "/locations/urban-mill-downtown?format=atom"
  end
  
  private
  def assert_permanently_redirected(url, destination = false)
    get url
    assert_response 301
    assert_redirected_to destination if destination
    follow_redirect!
    assert_response :success
  end
end
