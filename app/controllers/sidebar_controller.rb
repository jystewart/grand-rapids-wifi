class SidebarController < ApplicationController
  @@options = ['highly_rated', 'least_comments', 'most_comments', 'recent_comments']
  caches_page :highly_rated, :least_comments, :most_comments, :recent_comments
  
  layout nil
  
  def self.options
    @@options
  end

  def highly_rated
    @sidebar_title = 'Most Highly Rated Hotspots'
    @locations = Location.highly_rated
    render :action => 'list'
  end
  
  def least_comments
    @sidebar_title = 'Hotspots In Need Of Comments'
    @locations = Location.least_comments
    render :action => 'list'
  end
  
  def most_comments
    @sidebar_title = 'Most Commented On Hotspots'
    @locations = Location.most_comments
    render :action => 'list'
  end
  
  def recent_comments
    @sidebar_title = 'Recently Commented On'
    @locations = Location.recent_comments
    render :action => 'list'
  end
end
