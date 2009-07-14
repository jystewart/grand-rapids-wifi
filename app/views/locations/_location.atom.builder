xml.author { 
  xml.name 'James Stewart'
  xml.uri 'http://www.ketlai.co.uk'
  xml.email 'james@ketlai.co.uk'
}
xml.id location_url(location)
xml.updated location.updated_at.xmlschema 
xml.published location.created_at.xmlschema
xml.title location.name
xml.link "rel" => "alternate", "type" => "text/html", "href" => location_url(location)

xml.content :type => 'xhtml' do 
  xml.div :xmlns => 'http://www.w3.org/1999/xhtml' do
    xml.p "The details of the WiFi hotspot at: #{location.name} have been updated. Find out more at:"
    xml.p { xml.a location_url(location), "href" => location_url(location) }
  end
end

if location.geocode
  xml.geo :lat, location.geocode.latitude
  xml.geo :long, location.geocode.longitude
  xml.georss :point, location.geocode.latitude.to_s + ' ' + location.geocode.longitude.to_s
end

xml.category :term => location.name
xml.category :term => SITE_NAME
xml.category :term => 'WiFi'
xml.category :term => 'Grand Rapids'
xml.category :term => 'Hotspots'
xml.category :term => 'Wireless Internet'