xml.id story_url(entry.commentable, :anchor => 'comment' + entry.id.to_s)
xml.title SITE_NAME + ': Comment on ' + entry.commentable.headline
xml.link 'rel' => 'alternate', 'type' => 'text/html', 'href' => story_url(entry.commentable, :anchor => 'comment' + entry.id.to_s)
xml.content :type => 'xhtml' do 
  xml.div :xmlns => 'http://www.w3.org/1999/xhtml' do
    xml.p entry.blog_name + ' said regarding ' + entry.commentable.headline + '...'
    xml.p entry.excerpt
  end
end
xml.published entry.created_at.xmlschema