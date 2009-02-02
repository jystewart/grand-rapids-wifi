ActionController::Routing::Routes.draw do |map|
  map.resources :neighbourhoods

  # Add your own custom routes here.
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Here's a sample route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.connect '', :controller => "welcome"
  map.admin '/admin', :controller => 'admin'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'

  map.resources :comments, :member => {:junk => :post, :reprieve => :post}, :collection => {:bulk => :post}
  map.resources :ratings
  map.resources :news, :collection => {:archive => :get}
  map.resource  :session
  map.resources :users

  map.resources :locations, :collection => {:map => :get, :list => :get}

  map.open 'open/now', :controller => 'search', :action => 'results', :open => 'now'
  map.zip 'zip/:zip', :controller => 'search', :action => 'results'

  map.connect 'rss/:action', :controller => 'feed', :format => 'rss'
  map.connect 'rss1/:action', :controller => 'feed', :format => 'rss'
  map.connect 'atom/:action', :controller => 'feed', :format => 'atom'
  map.connect 'feed.:format', :controller => 'feed', :action => 'index'
  map.connect 'feeds/:action.:format', :controller => 'feed'
  map.connect 'feeds', :controller => 'feed', :action => 'index'

  map.archive 'news/archive/:year/:month', :controller => 'news', :action => 'archive'

  map.connect 'rdf', :controller => 'location', :action => 'index', :format => 'rdf'

  # map.connect '/location/view/:id.:format', :controller => 'location', :action => 'view'
  # map.connect '/location/:id.:format', :controller => 'location', :action => 'view'
    
  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end
