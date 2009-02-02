class CommentSweeper < ActionController::Caching::Sweeper
  observe Comment
  
  def after_create(comment)
    if comment.commentable_type == 'Location'
      expire_page :controller => 'location', :action => 'view', :id => comment.commentable.permalink
      expire_page :controller => 'location', :action => 'feed', :id => comment.commentable.permalink
      expire_page :controller => 'location', :action => 'rdf', :id => comment.commentable.permalink
    else
      expire_page :controller => 'news', :action => 'index'
      expire_page :controller => 'news', :action => 'story', :id => comment.commentable.permalink      
    end
    expire_page :controller => 'feed', :action => 'comments'
    expire_page :controller => 'feed', :action => 'index'
  end
end