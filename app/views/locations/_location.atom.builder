xml.author { 
  xml.name 'James Stewart'
  xml.uri 'http://jystewart.net'
  xml.email 'james@jystewart.net'
}
xml.id location_url(entry)
xml.updated entry.updated_at.xmlschema 
xml.published entry.created_at.xmlschema
xml.title entry.name
xml.link "rel" => "alternate", "type" => "text/html", "href" => location_url(entry)

xml.content :type => 'xhtml' do 
  xml.div :xmlns => 'http://www.w3.org/1999/xhtml' do
    xml.p "The details of the WiFi hotspot at: #{entry.name} have been updated. Find out more at:"
    xml.p { xml.a location_url(entry), "href" => location_url(entry) }
  end
end

if entry.geocode
  xml.geo :lat, entry.latitude
  xml.geo :long, entry.longitude
  xml.georss :point, entry.latitude.to_s + ' ' + entry.longitude.to_s
end

xml.category :term => entry.name
xml.category :term => SITE_NAME
xml.category :term => 'WiFi'
xml.category :term => 'Grand Rapids'
xml.category :term => 'Hotspots'
xml.category :term => 'Wireless Internet'