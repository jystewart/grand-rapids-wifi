xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.feed "xml:lang"=>"en-US", "xml:base"=>"http://#{controller.request.host}/feed", 
  "xmlns"=>"http://www.w3.org/2005/Atom", 
  "xmlns:dc" => "http://purl.org/dc/elements/1.1/", 
  "xmlns:geo" => 'http://www.w3.org/2003/01/geo/wgs84_pos#' do

  xml.title SITE_NAME + ": News Updates"
  xml.id "http://grwifi.net/atom/news"
  xml.link "rel" => "alternate", "type" => "text/html", "href" => url_for(:only_path => false, :controller => 'news')
  xml.link "rel" => "self", "type" => "application/atom+xml", "href" => url_for(:only_path => false, :controller => 'feed', :action => 'news')
  xml.rights "Creative Commons Attribution-NonCommercial-ShareAlike 2.0 http://creativecommons.org/licenses/by-nc-sa/2.0/ "

  xml.updated @stories.first.created_at.xmlschema unless @stories.empty?

  for entry in @stories

    xml.entry do
  
			xml << render(:partial => 'story', :locals => {:entry => entry})
			
    end
  end   
end
