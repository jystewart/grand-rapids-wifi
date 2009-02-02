xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.rdf :RDF, "xml:lang"=>"en-US", "xml:base"=>"http://#{controller.request.host}/feed", 
  "xmlns:rdf" => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
  "xmlns:sy" => "http://purl.org/rss/1.0/modules/syndication/",
  "xmlns:dc" => "http://purl.org/dc/elements/1.1/", 
  'xmlns:georss' => 'http://www.georss.org/georss',
  "xmlns" => "http://purl.org/rss/1.0/" do

  xml.channel "rdf:about" => "http://grwifi.net/rss/locations" do 
    xml.title SITE_NAME + ": Updated Hotspot Locations"
    xml.link url_for(:only_path => false, :controller => 'welcome')
    xml.description "Details of update to our index of wireless hotspots in Grand Rapids, MI"
    xml.dc :publisher, "James Stewart"
    xml.dc :creator, "James Stewart (mailto:james@jystewart.net)"
    xml.dc :date, @entries.first.created_at.xmlschema unless @entries.empty?
    xml.items do 
      xml.rdf :Seq do
        for entry in @entries
          if entry.commentable_type == 'Location'
            xml.rdf :li, 'resource' => location_url(entry, :anchor => 'comment' + entry.id.to_s)
          else
            xml.rdf :li, 'resource' => url_for(:only_path => false, :controller => 'news', :action => 'story', 
              :id => entry.commentable.permalink, :anchor => 'comment' + entry.id.to_s)
          end
        end
      end
    end
  end
  
  for entry in @entries 
    if entry.commentable_type == 'Location'
      about = location_url(entry, :anchor => 'comment' + entry.id.to_s)
    else
      about = url_for(:only_path => false, :controller => 'news', :action => 'story', :id => entry.commentable.permalink, 
        :anchor => 'comment' + entry.id.to_s)
    end
    xml.item 'rdf:about' => about do
      if entry.commentable_type == 'Location'
        xml.title SITE_NAME + ': Comment on ' + entry.commentable.name
        xml.link location_url(entry, :anchor => 'comment' + entry.id.to_s)
        xml.dc :subject, entry.commentable.name
        xml.description entry.blog_name + ' said regarding ' + entry.commentable.name + ' ... ' + entry.excerpt
        unless entry.commentable.geocode.nil?
          xml.georss :point, "#{entry.commentable.geocode.latitude} #{ entry.commentable.geocode.longitude}"
        end
      else
        xml.title SITE_NAME + ': Comment on ' + entry.commentable.headline
        xml.link url_for(:only_path => false, :controller => 'news', :action => 'story', :id => entry.commentable.permalink, 
          :anchor => 'comment' + entry.id.to_s)
        xml.description entry.blog_name + ' said regarding ' + entry.commentable.headline + ' ... ' + entry.excerpt
      end
      xml.dc :subject, 'WiFi'
      xml.dc :subject, 'Grand Rapids'
      xml.dc :subject, 'Hotspots'
    end
  end
end
