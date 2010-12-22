class RatingsController < InheritedResources::Base
  before_filter :authenticate_administrator!, :only => 'index'
  before_filter :block_bad_referers, :only => :create
  
  belongs_to :location
  
  def index
    @ratings = Vote.listings
  end
end
