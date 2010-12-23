class SubmissionsController < ApplicationController
  def new
    @location = Location.new
    @submitter = Submitter.new
  end
  
  def create
    @submitter = Submitter.new(params[:submitter])
    @location = Location.new(params[:location])
    @comparisons = Location.find_similar(@location.name)
    
    if @submitter.valid? and @location.valid? and (@comparisons.empty? or params[:is_sure] == '1')
      @location.save
      AdminNotifier.submission(@location, @submitter).deliver
      redirect_to :action => 'index', :notice => 'Thank you'
    else
      render :action => 'new' and return
    end
  end
end
