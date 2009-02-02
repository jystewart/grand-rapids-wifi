class RatingsController < ApplicationController
  before_filter :login_required, :only => 'index'
  verify :params => :vote, :only => :create, :redirect => :back

  def index
    @ratings = Vote.find(:all, :order => 'entered_at DESC', :include => :location)
  end

  def create
    render :nothing => true, :status => 403 and return if request.env['HTTP_REFERER'].nil?

    @location = Location.find_by_permalink(params[:location_id])
    @rating = @location.votes.create(:rating => params[:vote]['rating'], :voter => request.remote_ip)

    flash[:notice] = 'Thank you. Your rating has been saved'
    redirect_to :back
  end
end
