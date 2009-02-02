class AboutController < ApplicationController
  caches_page :index
  caches_page :links
  caches_page :help
  caches_page :feeds
end
