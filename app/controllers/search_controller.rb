class SearchController < ApplicationController
  caches_page :index

  def results
    if params[:open] == 'now'
      @locations = Location.open_now
    else
      params[:location] ||= {}
      params[:location][:zip] ||= params[:zip]
      @locations = Location.search(params[:location], params[:date], params[:keyword])
    end
    
    if params[:format] and params[:format] == 'map'
      build_map @locations
      response.headers['Content-Type'] = 'text/html; charset=utf-8'
      render and return
    end
    
    respond_to do |wants|
      wants.html
      wants.json { render :json => @locations.to_json }
      wants.xml { render :xml => @locations.to_xml(:include => :openings) }
    end

  end  
end
