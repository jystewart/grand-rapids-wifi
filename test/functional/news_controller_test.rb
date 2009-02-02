require File.dirname(__FILE__) + '/../test_helper'
require 'news_controller'

# Re-raise errors caught by the controller.
class NewsController; def rescue_action(e) raise e end; end

class NewsControllerTest < Test::Unit::TestCase
  fixtures :users, :news, :pings, :notifiables
  
  def setup
    @controller = NewsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_archive_requires_month_and_year
    get :archive, :month => '12'
    assert_response :redirect
    assert_redirected_to :action => 'index'
    
    get :archive, :year => '2006'
    assert_response :redirect
    assert_redirected_to :action => 'index'
    
    get :archive, :month => '12', :year => '2006'
    assert_response :success
  end

  # Test all protected methods require login
  def test_should_require_login
    get :destroy, :id => 'google-maps-complete'
    assert_response :redirect
    get :update, :id => 'google-maps-complete'
    assert_response :redirect
    get :create
    assert_response :redirect
  end
  
  def test_should_be_able_to_get_atom_for_news
    get :index, :format => 'atom'
    assert_response :success
  end

  def test_story_should_redirect
    get :story, :id => 'google-maps-complete'
    assert_response :redirect
  end
  
  def test_should_show_story
    get :show, :id => 'google-maps-complete'
    assert_response :success
    assert_select 'h2', 'Complete Google Maps Integration'
    assert_valid_markup
  end
  
  def test_404_for_non_existent_story
    get :show, :id => 'my-fake-story'
    assert_response 404
  end
  
  def test_should_produce_list
    get :index
    assert_response :success
    assert_template 'news/index'
    assert_valid_markup
  end
  
  def test_should_require_post
    login_as :quentin
    get :destroy, :id => 'google-maps-complete'
    assert_response :redirect
  end
  
  def test_edit_should_return_form
    login_as :quentin
    get :edit, :id => 'google-maps-complete'
    assert_response :success
    assert_select 'form[action=/news/google-maps-complete/edit]'
  end
  
  def test_create_should_return_form
    login_as :quentin
    get :create
    assert_response :success
    assert_select 'form[action=/news]'
  end
  
  def test_edit_should_work
    login_as :quentin
    updated = { :permalink => 'google-maps-complete', :headline => 'Complete Google Maps Integration Part 2',
      :external => 'grwifi.net/search', :id => '22', :extended => '',
      :content => 'As promised, I\'ve spent more time working on google maps integration for the site, and the results are now live. Behind the scenes I\'ve actually completely reworked the search code so that it\'s much easier to add on extra ways of viewing the search results and now every search on the site can be viewed on a map, with links between map view and regular view. There are a few locations missing from the map view as I haven\'t been able to pinpoint longitude/latitude for them, but hopefully the gaps will be filled soon.'}
    post :update, :id => 'google-maps-complete', :story => updated
    assert_response :redirect
    assert_redirected_to :action => 'story', :id => 'google-maps-complete'
  end
  
  def test_404_for_edit_bad_story
    login_as :quentin
    get :edit, :id => 'my-fake-story'
    assert_response 404
  end
  
  def test_create_should_work
    login_as :quentin
    assert_difference "News.count" do
      post :create, :story => {:headline => 'My Test Story', :content => "Some text here", :permalink => 'my-test-story'}
      assert_response :redirect
    end
  end
  
  def test_delete_should_work
    login_as :quentin
    assert_difference "News.count", -1 do
      delete :destroy, :id => 'google-maps-complete'
      assert_response :redirect
    end
  end
  
  def test_404_for_delete_bad_story
    login_as :quentin
    post :destroy, :id => 'my-fake-story'
    assert_response 404
  end

  def test_sends_pings
    assert_difference "Ping.count", Notifiable.count do
      login_as :quentin
      post :create, :story => {:headline => 'My Test Story', :content => "Some text here", :permalink => 'my-test-story'}
    end
  end
end