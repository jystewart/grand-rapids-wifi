xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.rdf :RDF, "xml:lang"=>"en-US", "xml:base"=>"http://#{controller.request.host}/feed", 
  "xmlns:rdf" => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
  "xmlns:sy" => "http://purl.org/rss/1.0/modules/syndication/",
  "xmlns:dc" => "http://purl.org/dc/elements/1.1/", 
  "xmlns:geo" => 'http://www.w3.org/2003/01/geo/wgs84_pos#',
  'xmlns:georss' => 'http://www.georss.org/georss',
  "xmlns" => "http://purl.org/rss/1.0/" do

  xml.channel "rdf:about" => "http://grwifi.net/rss/locations" do 
    xml.title SITE_NAME + ": Updated Hotspot Locations"
    xml.link url_for(:only_path => false, :controller => 'location')
    xml.description "Details of update to our index of wireless hotspots in Grand Rapids, MI"
    xml.dc :publisher, "James Stewart"
    xml.dc :creator, "James Stewart (mailto:james@jystewart.net)"
    xml.dc :date, @entries.first.updated_at.xmlschema unless @entries.empty?
    xml.items do 
      xml.rdf :Seq do
        for entry in @entries
          xml.rdf :li, 'resource' => location_url(entry)
        end
      end
    end
  end
  
  for entry in @entries 
    xml.item 'rdf:about' =>location_url(entry) do
      xml.title entry.name
      xml.link location_url(entry)
      xml.description "The details of the WiFi hotspot at: #{entry.name} have been updated. Find out more at:
        " + location_url(entry)
      xml.dc :subject, 'WiFi'
      xml.dc :subject, 'Grand Rapids'
      xml.dc :subject, 'Hotspots'
      unless entry.geocode.nil?
        xml.geo :lat, entry.geocode.latitude
        xml.geo :long, entry.geocode.longitude
        xml.georss :point, "#{entry.geocode.latitude} #{entry.geocode.longitude}"
      end
    end
  end
end
