# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'xmlrpc/client'

class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include AuthenticatedSystem

  protected
    def build_map(locations)
    
      @map = Mapstraction.new('map', :google)
      @map.control_init(:small => true)

      if locations.size > 1 
        longitude = Geocode.average(:longitude)
        latitude = Geocode.average(:latitude)
        sorted_latitudes = locations.collect(&:geocode).compact.collect(&:latitude).sort
        sorted_longitudes = locations.collect(&:geocode).compact.collect(&:longitude).sort
        @map.center_zoom_on_bounds_init([[sorted_latitudes.first, sorted_longitudes.first], 
          [sorted_latitudes.last, sorted_longitudes.last]])
      elsif locations.first.nil? or locations.first.geocode.nil?
        return
      else
        longitude = locations.first.geocode.longitude
        latitude = locations.first.geocode.latitude
        @map.center_zoom_init([latitude, longitude], 14)
      end

      locations.each do |@location|
        unless @location.nil? or @location.geocode.nil?
          @map.marker_init(Marker.new([@location.geocode.latitude, @location.geocode.longitude], 
            :label => @location.name, :info_bubble => render_to_string(:partial => 'locations/bubble.html.erb')))
        end
      end
    end
end