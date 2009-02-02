class LocationSweeper < ActionController::Caching::Sweeper
  observe Location
  
  def after_create(location)
    expire_public_pages(location)
  end
  
  def after_update(location)
    expire_public_pages(location)
  end
  
  def after_destroy(location)
    expire_public_pages(location)
  end
  
  private
  def expire_public_pages(location)
    location.neighbourhoods.each do |n|
      expire_page :controller => 'neighbourhoods', :action => 'show', :id => n.permalink
    end
    expire_page :controller => 'location', :action => 'show', :id => location.permalink
    expire_page :controller => 'location', :action => 'index'
    expire_page :controller => 'location', :action => 'map'
    expire_page :controller => 'search', :action => 'index'   
    expire_page :controller => 'welcome', :action => 'index'
    expire_page :controller => 'feed', :action => 'locations'
    expire_page :controller => 'feed', :action => 'index'
  end
end