class WelcomeController < ApplicationController
  caches_page :index

  def index
    @locations = Location.find(:all, :limit => 3, 
      :conditions => {:status => 'proven', :visibility => 'yes'}, 
      :order => 'updated_at DESC')
    @stories = News.find(:all, :limit => 2, :order => 'created_at DESC')
  end
end
