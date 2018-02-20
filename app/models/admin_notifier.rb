class AdminNotifier < ActionMailer::Base
  default_url_options[:host] = DEFAULT_HOST
  default :from => SITE_EMAIL, :to => ADMIN_EMAIL

  def submission(location, submitter)
    @location = location
    @submitter = submitter

    mail(:subject => 'Hotspot Submission For GRWiFi')
  end

  def comment(comment)
    @comment = comment

    mail(:subject => 'New Comment at GRWiFi')
  end
end
