class CommentObserver < ActiveRecord::Observer
  def after_save(comment)
    mail = AdminNotifier.deliver_comment(comment)
  rescue => err
    comment.logger.warn "Unable to deliver comment notification email " + err.to_s
  end
end
