require 'ratings_app'

Wifi::Application.routes.draw do
  # Redirects
  match "locations/:name/feed", :to => redirect("/locations/%{name}.atom")
  match "locations/:name/rdf", :to => redirect("/locations/%{name}.rdf")
  match "locations/view/:name(.:format)", :to => redirect("/locations/%{name}.%{format}")
  match "locations/.rss", :to => redirect("/locations.atom")
  
  match 'rss/:item', :to => redirect('/%{item}.atom')
  match 'rss1/:item', :to => redirect('/%{item}.rdf')
  match 'atom/:item', :to => redirect('/%{item}.atom')
  match 'rdf', :to => redirect('/locations.rdf')
  match 'feed.:format', :to => redirect("/welcome/index.%{format}")
  
  match 'news/archive/:year/:month', :to => redirect("/stories/archive/%{year}/%{month}")
  match 'news/story/:id', :to => redirect("/stories/%{id}")
  match 'news/:id', :to => redirect("/stories/%{id}")
  match 'news(.:format)', :to => redirect("/stories.%{format}")
  match 'news', :to => redirect("/stories")

  match '/ratings', :to => RatingsApp.new
  
  # Regular routes

  match 'admin' => 'admin#index', :as => :admin
  
  resources :comments do
    collection do
      post :bulk
    end
    member do
      post :junk
      post :reprieve
    end
  end
  
  resources :stories do
    collection do
      get :archive
    end
  end
  
  resources :locations do
    resources :votes
    member do
      post :change_visibility
    end
    collection do
      get :list
      get :map
    end
  end
  
  devise_for :administrators
  
  resources :neighbourhoods, :submissions
  
  match 'open/now' => 'search#results', :as => :open, :open => 'now'
  match 'zip/:zip' => 'search#results', :as => :zip
  
  match 'stories/archive/:year/:month' => 'stories#archive', :as => :archive
  
  match 'search/results(.:format)' => 'search#results', :as => :search_results
  match 'search' => 'search#index', :as => :search
         
  match 'about', :to => 'about#index', :as => :about
  match 'about/links', :to => 'about#links', :as => :links
  match 'about/help', :to => 'about#help', :as => :help
  match 'about/feeds', :to => 'about#feeds', :as => :feeds_info
  match 'submit', :to => 'submissions#new', :as => :new_submission
  
  root :to => 'welcome#index'
end
