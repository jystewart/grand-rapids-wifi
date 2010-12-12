class RatingsController < ApplicationController
  before_filter :authenticate_administrator!, :only => 'index'
  before_filter :block_bad_referers, :only => :create
  
  def index
    @ratings = Vote.listings
  end

  def create
    @location = Location.find_by_permalink(params[:location_id])
    @rating = @location.votes.create(:rating => params[:vote]['rating'], :voter => request.remote_ip)

    flash[:notice] = 'Thank you. Your rating has been saved'
    redirect_to :back
  end
end
