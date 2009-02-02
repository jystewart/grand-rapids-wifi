require File.dirname(__FILE__) + '/../test_helper'
require 'comments_controller'

# Re-raise errors caught by the controller.
class CommentsController; def rescue_action(e) raise e end; end

class CommentsControllerTest < Test::Unit::TestCase
  fixtures :locations, :comments, :users, :news

  def setup
    @controller = CommentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.env['HTTP_USER_AGENT'] = 'Rails Testing Environment'
    @request.env["HTTP_REFERER"] = 'http://test.host/'
  end

  def test_bulk_redirects
    post :bulk
    assert_response :redirect
  end

  def test_deny_unless_referrer
    @request.env["HTTP_REFERER"] = nil
    assert_no_difference "Comment.count" do
      post :create, :comment => {:commentable_type => "News", :uri => "james@james.com", 
        :blog_name => "James", :title => "Useful, thank you", :excerpt => "I couldn't agree more. That's a very useful new feature. Thank you.", :commentable_id => "22"}
      assert_response :forbidden
    end
  end

  def test_hides_spam_comment
    assert_difference "Comment.count" do
      @request.env['REMOTE_ADDR'] = '61.95.192.50'
      post :create, :comment => {:commentable_type => "Location", 
        :uri => "http://beam.to/bigboobs69", :blog_name => "Freexxx", 
        :title => "testing", 
        :excerpt => "[url=http://beam.to/bigboobs69][img]http://bigfatsearch.biz/vid/2.jpeg[/img]FREE BIG BOOBS[/url]", 
        :commentable_id => "46"}
      assert_response :redirect
      assert_flash_has :notice, 'Thank you. Your comment has been held for approval'
    end
  end

  def test_destroys_spam_comment
    assert_difference "Comment.count", -1 do
      post :junk, :id => 200
      assert_response :redirect
      assert_flash_has :notice, 'Comment successfully deleted as spam'
    end
  end

  def test_create_news_comment
    assert_difference "Comment.count" do
      post :create, :comment => {:commentable_type => "News", :uri => "james@james.com", 
        :blog_name => "James", :title => "Useful, thank you", :excerpt => "I couldn't agree more. That's a very useful new feature. Thank you.", :commentable_id => "22"}
      assert_response :redirect
    end
  end
  
  def test_create_location_comment
    assert_difference "Comment.count" do
      post :create, :comment => {:commentable_type => "Location", :uri => "james@james.com", 
        :blog_name => "James", :title => "testing", :excerpt => "again!", :commentable_id => "46"}
      assert_response :redirect
      assert_redirected_to location_url(Location.find(46))
    end
  end
  
  def test_new_comment_triggers_email
    assert_difference "ActionMailer::Base.deliveries.size" do
      post :create, :comment => {:commentable_type => "Location", :uri => "james@james.com", 
        :blog_name => "James", :title => "testing", :excerpt => "again!", :commentable_id => "46"}
      assert_response :redirect
    end
  end
  
  def test_404_for_bad_commentable_type
    post :create, :comment => {:commentable_type => "FakeType", :uri => "james@james.com", 
      :blog_name => "James", :title => "testing", :excerpt => "again!", :commentable_id => "46"}
    assert_response 404
  end
  
  def test_404_for_bad_commentable_id
    post :create, :comment => {:commentable_type => "News", :uri => "james@james.com", 
      :blog_name => "James", :title => "testing", :excerpt => "again!", :commentable_id => "46"}
    assert_response 404
  end
  
  def test_requires_post_to_create
    get :create
    assert_response :redirect
  end
  
  def test_requires_login_to_edit
    get :edit
    assert_response :redirect
  end
  
  def test_requires_login_to_destroy
    assert_no_difference "Comment.count" do
      post :destroy, :id => 123
      assert_response :redirect
    end
  end
  
  def test_requires_post_to_destroy
    login_as :quentin
    assert_no_difference "Comment.count" do
      get :destroy, :id => 123
      assert_response :redirect
    end
  end
  
  def test_destroy_works
    login_as :quentin
    assert_difference "Comment.count", -1 do
      delete :destroy, :id => 123
      assert_response :redirect
    end
  end
  
  def test_edit_works
    login_as :quentin
    put :update, :id => 61, :comment => {:id => 61, :commentable_type => "Location", 
      :uri => "http://james.anthropiccollective.org/archives/2005/01/wifi_at_global.html", 
      :blog_name => "little more than a placeholder", :title => "WiFi at Globally Infused", :trackback => true,
      :excerpt => "I'd been meaning to get back to Global Infusions with my laptop since I first noticed that they offer wifi...", 
      :commentable_id => "49", :user_ip => '67.15.84.42'}
    assert_response :redirect
    assert_flash_exists
    assert_flash_has :notice, 'Comment was successfully updated.'
    assert_equal 'WiFi at Globally Infused', Comment.find(61).title
  end
  
  def test_email_sent_on_creation
    assert_difference "ActionMailer::Base.deliveries.size" do
      assert_difference "Comment.count" do
        post :create, :comment => {:commentable_type => "News", :uri => "james@james.com", 
          :blog_name => "James", :title => "testing", :excerpt => "again!", :commentable_id => "22"}
        assert_response :redirect
      end
    end
  end
end
