class CommentsController < ApplicationController
  before_filter :authenticate, :except => :create
  before_filter :load_comment, :except => [:index, :new, :create, :bulk]

  verify :method => :post, :only => :create, :redirect_to => {:controller => 'welcome', :action => 'index'}
  verify :method => [:post, :delete], :only => :destroy, :redirect_to => {:controller => 'welcome', :action => 'index'}
  verify :params => 'comment', :only => :create, :render => {:nothing => true, :status => 404}

  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  rescue_from NameError, :with => :render_404

  cache_sweeper :comment_sweeper
    
  layout 'admin'

  def index
    @comments = Comment.paginate :per_page => 30, :order => 'created_at DESC', :page => params[:page]

    respond_to do |wants|
      wants.html
      wants.xml { render :xml => @comments.to_xml }
    end
  end

  def show
    respond_to do |wants|
      wants.xml { render :xml => @comment.to_xml }
      wants.html
    end
  end

  def new
    @comment = Comment.new
  end

  def create
    render :nothing => true, :status => 403 and return unless request.env['HTTP_REFERER']

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

  def edit
  end
  
  def update
    if @comment.update_attributes!(params[:comment])
      respond_to do |wants|
        wants.html {
          flash[:notice] = 'Comment was successfully updated.'
          redirect_to :action => 'index' and return
        }
        wants.xml { render :xml => @comment.to_xml and return }
      end
    end
    render :action => 'edit' and return
  rescue => err
    render :nothing => true and return
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

  def destroy
    @comment.destroy

    respond_to do |wants|
      wants.html {
        flash[:notice] = 'Comment successfully deleted'
        redirect_back_or_default(:action => 'index')
      }
      wants.js
    end
    
  end
  
  protected
    def load_comment
      @comment = Comment.find(params[:id])
    end
end
