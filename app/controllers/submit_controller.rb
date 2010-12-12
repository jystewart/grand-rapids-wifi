class SubmitController < ApplicationController
  
  def index
    @location = Location.new
    @submitter = Submitter.new
    7.times { |time| @location.openings.build }
  end
  
  def preview
    @location = Location.new(params[:location])
    @submitter = Submitter.new(params[:submitter])
    l = @location.valid?
    s = @submitter.valid?
    render :action => 'index' and return if not l or not s
    session[:location] = @location
    session[:submitter] = @submitter
    @comparisons = Location.find_similar(@location.name)
  rescue ActiveRecord::StatementInvalid 
    @comparisons = []
  end
  
  def complete
    render :nothing => true, :status => 412 and return if session[:location].nil?

    @location = session[:location]
    session[:location] = nil
    @submitter = session[:submitter]
    session[:submitter] = nil

    render :action => 'index' and return unless @location.save

    mail = AdminNotifier.create_submission(@location, @submitter)
    AdminNotifier.deliver(mail)
    redirect_to '/submit/thankyou' and return
  end
  
  def thankyou
  end
end
