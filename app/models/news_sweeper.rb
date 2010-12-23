class NewsSweeper < ActionController::Caching::Sweeper
  observe Story
  
  def after_create(story)
    expire_public_pages(story) 
  end
  
  def after_update(story)
    expire_public_pages(story) 
  end
  
  def after_destroy(story)
    expire_public_pages(story) 
  end
  
  private
  def expire_public_pages(story)
    expire_page :controller => 'news', :action => 'index'
    expire_page :controller => 'news', :action => 'story', :id => story.id
    expire_page :controller => 'welcome', :action => 'index'
    expire_page :controller => 'feed', :action => 'news'
    expire_page :controller => 'feed', :action => 'index'
  end
end