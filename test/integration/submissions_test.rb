require "#{File.dirname(__FILE__)}/../test_helper"

class SubmissionsTest < ActionController::IntegrationTest
  fixtures :locations, :news, :comments, :users

  def test_submission_updates_homepage
    get '/submit'
    assert_response :success

    post '/submit/preview', :location => {:status => 'proven', :zip => '49503', :permalink => 'my-test-location', 
        :name => 'My Test Location', :street => '65 Auburn Ave NE'}, 
      :submitter => {:name => 'James Stewart', :connection => 'Site Admin', :email => 'james@jystewart.net'}
    assert_response :success

    post '/submit/complete'
    assert_response :redirect
    assert_redirected_to "/submit/thankyou"
  
    assert_expire_pages("/") do |*urls|
      post '/session', :login => 'quentin', :password => 'quentin'
      assert_response :redirect
      assert session[:user]
      
      get '/locations/my-test-location/edit'
      assert_response :success

      post '/locations/my-test-location', :_method => 'put',
        :location => {:status => 'proven', :zip => 49503, :permalink => 'my-test-location', 
          :name => 'My Test Location', :street => '65 Auburn Ave NE'}
      assert_response :redirect
      assert_redirected_to '/locations/my-test-location'
    end
  end
end
