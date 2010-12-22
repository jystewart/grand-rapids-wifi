class CommentsController < InheritedResources::Base
  before_filter :authenticate_administrator!, :except => [:index, :create]
  before_filter :block_bad_referers, :only => :create
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  cache_sweeper :comment_sweeper
    
  layout 'admin'

  def index
    if request.format.atom?
      @entries = Comment.visible.limit(10).order('created_at DESC')
      @entries = @entries.reject { |c| c.commentable.nil? }
      respond_to do |wants|
        wants.atom
        wants.rss
      end
    else
      authenticate_administrator!
      index!
    end
  end

  def create
    entity = params[:comment][:commentable_type].constantize.find(params[:comment][:commentable_id])
    @review = entity.comments.create(params[:comment].merge(:user_ip => request.remote_ip, 
      :trackback => 0, :user_agent => request.env['HTTP_USER_AGENT']))

    respond_to do |wants|
      wants.html do
        if @review.new_record?
          render :action => 'new'
        else
          flash[:notice] = @review.hide? ? 'Thank you. Your comment has been held for approval' : 'Comment saved'
          redirect_to url_for(@review.commentable)
        end
      end
      wants.js do
        if @review.new_record?
          render :update do |page| 
            page.alert(@review.errors.inspect)
          end
        else
          render
        end
      end
    end
  end

  def bulk
    case params[:act]
    when 'Spam'
      c = Comment.find(:all, :conditions => ['id IN (?)', params[:ids]])
      c.each { |comment| comment.mark_as_spam }
    when 'Delete'
      Comment.delete_all ['id IN (?)', params[:ids]]
    when 'Reprieve'
      c = Comment.find(:all, :conditions => ['id IN (?)', params[:ids]])
      c.each { |comment| comment.mark_as_ham }
    end
    
    redirect_back_or_default(:action => 'index') and return
  end

  def junk
    @comment.mark_as_spam

    respond_to do |wants|
      wants.html {
        flash[:notice] = 'Comment successfully deleted as spam'
        redirect_back_or_default(:action => 'index')
      }
      wants.js
    end
  end
  
  def reprieve
    @comment.mark_as_ham

    respond_to do |wants|
      wants.html {
        flash[:notice] = 'Comment no longer considered spam'
        redirect_back_or_default(:action => 'index')
      }
      wants.js
    end
  end
  
  protected
     def collection
       @comments ||= end_of_association_chain.paginate(:page => params[:page])
     end
end
