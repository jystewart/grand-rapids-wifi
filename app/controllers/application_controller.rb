# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'xmlrpc/client'

class ApplicationController < ActionController::Base
  include Clearance::Authentication
  include ExceptionNotifiable

  protected
    def build_map(locations)
    
      @map = Mapstraction.new('map', :google)
      @map.control_init(:small => true)
      
      mappables = locations.reject { |l| l.geocode.nil? }
      
      if mappables.size > 1 
        longitude = Geocode.average(:longitude)
        latitude = Geocode.average(:latitude)
        sorted_latitudes = mappables.collect(&:geocode).compact.collect(&:latitude).sort
        sorted_longitudes = mappables.collect(&:geocode).compact.collect(&:longitude).sort
        @map.center_zoom_on_bounds_init([[sorted_latitudes.first, sorted_longitudes.first], [sorted_latitudes.last, sorted_longitudes.last]])
      elsif mappables.empty? or mappables.first.geocode.nil?
        return
      else
        longitude = mappables.first.geocode.longitude
        latitude = mappables.first.geocode.latitude
        @map.center_zoom_init([latitude, longitude], 14)
      end

      mappables.each do |location|
        info_bubble = render_to_string(
          :partial => 'locations/bubble.html.erb', :locals => {:location => location}
        )
        @map.marker_init(Marker.new([location.geocode.latitude, location.geocode.longitude], :label => location.name, :info_bubble => info_bubble))
      end
    end
end