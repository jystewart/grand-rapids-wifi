xml.instruct! :xml, :version=>'1.0', :encoding=>'UTF-8'
xml.feed 'xml:lang'=>'en-US', 'xml:base'=>"http://#{controller.request.host}/feed", 
  'xmlns'=>'http://www.w3.org/2005/Atom', 
  'xmlns:dc' => 'http://purl.org/dc/elements/1.1/', 
  'xmlns:georss' => 'http://www.georss.org/georss' do

  xml.title SITE_NAME + ': Recent Comments'
  xml.id 'http://grwifi.net/atom/comments'
  xml.link 'rel' => 'alternate', 'type' => 'text/html', 'href' => url_for(:only_path => false, :controller => "welcome")
  xml.link 'rel' => 'self', 'type' => 'application/atom+xml', 'href' => url_for(:only_path => false, :controller => 'feed', :action => 'comments')
  xml.rights 'Creative Commons Attribution-NonCommercial-ShareAlike 2.0 http://creativecommons.org/licenses/by-nc-sa/2.0/ '

  xml.updated @entries.first.created_at.xmlschema unless @entries.empty?

  for entry in @entries

    xml.entry do
      if entry.commentable_type == 'Location'
        xml << render(:partial => 'comments/location', :locals => {:entry => entry})
      else
        xml << render(:partial => 'comments/news', :locals => {:entry => entry})
      end
    end
  end   
end
