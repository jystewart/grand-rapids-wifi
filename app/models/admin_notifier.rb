class AdminNotifier < ActionMailer::Base
  default_url_options[:host] = DEFAULT_HOST 
  
  def submission(location, submitter)
    @subject    = 'Hotspot Submission For GRWiFi'
    @recipients = ADMIN_EMAIL
    @body['location'] = location
    @body['submitter'] = submitter
    @from       = SITE_EMAIL
    @sent_on    = Time.now
  end
  
  def comment(comment)
    @subject    = 'New Comment at GRWiFi'
    @recipients = ADMIN_EMAIL
    @body['comment'] = comment
    @from       = SITE_EMAIL
    @sent_on    = Time.now
    @content_type = "text/html"
  end
end
