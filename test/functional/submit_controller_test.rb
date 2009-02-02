require File.dirname(__FILE__) + '/../test_helper'
require 'submit_controller'

# Re-raise errors caught by the controller.
class SubmitController; def rescue_action(e) raise e end; end

class SubmitControllerTest < Test::Unit::TestCase
  fixtures :locations

  def setup
    @controller = SubmitController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
    assert_select 'fieldset[id=submitter]'
  end
  
  def test_post_restriction
    get :preview
    assert_response :redirect
    get :complete
    assert_response :redirect
  end

  def test_preview_works_with_openings
    post :preview, :submitter => {"name"=>"Kate", "connection"=>"I go there a lot :)", "email"=>"kate_devries@yahoo,com"}, 
      :location => {"status"=>"proven", "name"=>"Sculer Books and Music (Alpine only)", 
        "city"=>"Walker", "zip"=>"49544", "url"=>"www.schulerbooks.com", "state"=>"MI", "email"=>"Emily@schulerbooks.com",
        "phone_number"=>"616-647-0999", "free"=>"Yes", "ssid"=>"schuler-alpine", 
        "description"=>"Excellent locally-owned book and music store with a spacious cafe. So far the original 28th street location doesn't have wi-fi.  Try the soup and sandwiches, but you don't have to to use their wireless.  Also many comfy chairs around the bookstore, and fireplaces!", 
        "street"=>"3165 Alpine Ave", 'permalink' => 'schuler-alpine', "openings"=> {
          "0"=>{"opening_hour"=>"09", "opening_day"=>"1", "closing_hour"=>"22", "opening_minute"=>"00", "closing_day"=>"1", "closing_minute"=>"00"}, 
          "1"=>{"opening_hour"=>"09", "opening_day"=>"2", "closing_hour"=>"22", "opening_minute"=>"00", "closing_day"=>"2", "closing_minute"=>"00"}, 
          "2"=>{"opening_hour"=>"09", "opening_day"=>"3", "closing_hour"=>"22", "opening_minute"=>"00", "closing_day"=>"3", "closing_minute"=>"00"}, 
          "3"=>{"opening_hour"=>"09", "opening_day"=>"4", "closing_hour"=>"22", "opening_minute"=>"00", "closing_day"=>"4", "closing_minute"=>"00"}, 
          "4"=>{"opening_hour"=>"09", "opening_day"=>"5", "closing_hour"=>"23", "opening_minute"=>"00", "closing_day"=>"5", "closing_minute"=>"00"}, 
          "5"=>{"opening_hour"=>"09", "opening_day"=>"6", "closing_hour"=>"23", "opening_minute"=>"00", "closing_day"=>"6", "closing_minute"=>"00"}, 
          "6"=>{"opening_hour"=>"10", "opening_day"=>"7", "closing_hour"=>"20", "opening_minute"=>"00", "closing_day"=>"7", "closing_minute"=>"00"} 
        }}
    assert_response :success
  end

  def test_preview_location_fails
    post :preview, :submitter => {:name => 'James Stewart', :connection => 'Site Admin', :email => 'james@jystewart.net'},
      :location => {:status => 1, :zip => 49503, :permalink => 'my-test-location'}
    assert_response :success
    assert_template 'submit/index'
    assert_select 'div[class=errorExplanation][id=errorExplanation]' do
      assert_select 'li', :text => /Name can't be blank/
    end
  end
  
  def test_preview_submitter_fails
    post :preview, :submitter => {:name => 'James Stewart', :connection => 'Site Admin', :email => 'james'},
      :location => {:status => 1, :zip => 49503, :permalink => 'my-test-location', :name => 'My Test Location'}
    assert_response :success
    assert_template 'submit/index'
    assert_select 'div[class=errorExplanation][id=errorExplanation]' do
      assert_select 'li', :text => /Please specify a valid email address/
    end
  end

  def test_preview_valid
    post :preview, :submitter => {:name => 'James Stewart', :connection => 'Site Admin', :email => 'james@jystewart.net'},
      :location => {:status => 'proven', :zip => 49503, :name => 'My Test Location', :street => 'Near My House'}
    assert_response :success
    assert_template 'submit/preview'
  end

  def test_complete_412s_if_no_location
    post :complete
    assert_response 412
  end
  
  def test_emails_on_success
    assert_difference "ActionMailer::Base.deliveries.size" do
      @request.session[:location] = Location.new({:status => 'proven', :zip => 49503, :permalink => 'my-test-location', :name => 'My Test Location', :street => '65 Auburn Ave NE'})
      @request.session[:submitter] = Submitter.new({:name => 'James Stewart', :connection => 'Site Admin', :email => 'james@jystewart.net'})
      post :complete
      assert_response :redirect
      assert_redirected_to :action => 'thankyou'
    end
  end
  
  def test_complete_fails_if_not_save
    @request.session[:location] = Location.new({:status => 1, :zip => 49503, :permalink => 'common-ground', :name => 'My Test Location'})
    post :complete
    assert_response :success
    assert_template 'submit/index'
  end

  def test_thankyou
    get :thankyou
    assert_response :success
  end
end
