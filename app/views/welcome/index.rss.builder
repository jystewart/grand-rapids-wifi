xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.rdf :RDF, "xml:lang"=>"en-US", "xml:base"=>"http://#{controller.request.host}/feed", 
  "xmlns:rdf" => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
  "xmlns:sy" => "http://purl.org/rss/1.0/modules/syndication/",
  "xmlns:dc" => "http://purl.org/dc/elements/1.1/", 
  "xmlns:geo" => 'http://www.w3.org/2003/01/geo/wgs84_pos#',
  'xmlns:georss' => 'http://www.georss.org/georss',
  "xmlns" => "http://purl.org/rss/1.0/" do

  xml.channel "rdf:about" => "http://grwifi.net/rss/locations" do 
    xml.title SITE_NAME + ": News, Updated Hotspot Locations, and Comments"
    xml.link url_for(:only_path => false, :controller => 'welcome')
    xml.description "Details of update to our index of wireless hotspots in Grand Rapids, MI, plus new news stories and comments"
    xml.dc :publisher, "James Stewart"
    xml.dc :creator, "James Stewart (mailto:james@jystewart.net)"
    xml.dc :date, @entries.first.updated_at.xmlschema unless @entries.empty?
    xml.items do 
      xml.rdf :Seq do
        for entry in @entries
          xml.rdf :li, 'resource' => location_url(entry) if entry.class == Location
          xml.rdf :li, 'resource' => url_for(:only_path => false, :controller => 'news', :action => 'show', :id => entry.permalink) if entry.class == News
          xml.rdf :li, 'resource' => url_for(:only_path => false, :controller => 'news', :action => 'show', :id => entry.commentable.permalink) if entry.is_a?(Comment) and entry.commentable.is_a?(News)
          xml.rdf :li, 'resource' => location_url(entry.commentable, :anchor => 'comment' + entry.id.to_s) if entry.is_a?(Comment) and entry.commentable.is_a?(Location)
        end
      end
    end
  end
  
  for entry in @entries
    if entry.class == Location
      xml.item 'rdf:about' => location_url(entry) do
        xml.title entry.name
        xml.link location_url(entry)
        xml.description "The details of the WiFi hotspot at: #{entry.name} have been updated. Find out more at:
          " + location_url(entry)
        xml.dc :subject, 'WiFi'
        xml.dc :subject, 'Grand Rapids'
        xml.dc :subject, 'Hotspots'
        
        if entry.geocode
          xml.geo :lat, entry.geocode.latitude
          xml.geo :long, entry.geocode.longitude
          xml.georss :point, entry.geocode.latitude.to_s + ' ' + entry.geocode.longitude.to_s
        end
      end
    
    elsif entry.class == News
      xml.item 'rdf:about' => url_for(:only_path => false, :controller => 'news', :action => 'show', :id => entry.permalink) do
        xml.title entry.headline
        xml.link url_for(:only_path => false, :controller => 'news', :action => 'story', :id => entry.permalink)
        xml.description entry.content
        xml.dc :subject, 'WiFi'
        xml.dc :subject, 'Grand Rapids'
        xml.dc :subject, 'Hotspots'
      end
    elsif entry.class == Comment and entry.commentable_type == 'Location'
      about = location_url(entry.commentable, :anchor => 'comment' + entry.id.to_s)
      xml.item 'rdf:about' => about do
        xml.title SITE_NAME + ': Comment on ' + entry.commentable.name
        xml.link location_url(entry.commentable, :anchor => 'comment' + entry.id.to_s)
        xml.dc :subject, entry.commentable.name
        xml.description entry.blog_name + ' said regarding ' + entry.commentable.name + ' ... ' + entry.excerpt
        xml.dc :subject, 'WiFi'
        xml.dc :subject, 'Grand Rapids'
        xml.dc :subject, 'Hotspots'
      end
    elsif entry.class == Comment and entry.commentable_type == 'News'
      about = url_for(:only_path => false, :controller => 'news', :action => 'story', :id => entry.commentable.permalink, 
          :anchor => 'comment' + entry.id.to_s)
      xml.item 'rdf:about' => about do
        xml.title SITE_NAME + ': Comment on ' + entry.commentable.headline
        xml.link url_for(:only_path => false, :controller => 'news', :action => 'story', :id => entry.commentable.permalink, 
          :anchor => 'comment' + entry.id.to_s)
        xml.description entry.blog_name + ' said regarding ' + entry.commentable.headline + ' ... ' + entry.excerpt
        xml.dc :subject, 'WiFi'
        xml.dc :subject, 'Grand Rapids'
        xml.dc :subject, 'Hotspots'
      end
    end
  end
end
