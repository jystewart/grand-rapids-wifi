class VotesController < InheritedResources::Base
  before_filter :authenticate_administrator!, :only => 'index'
  before_filter :block_bad_referers, :only => :create
  before_filter :capture_voter, :only => :create
  
  belongs_to :location
  
  def index
    @ratings = Vote.listings
  end
  
  def create
    create! { @location }
  end

  protected
    def capture_voter
      params[:vote][:voter] = request.remote_ip
    end
end
