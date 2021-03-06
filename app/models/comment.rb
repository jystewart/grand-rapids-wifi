# == Schema Information
#
# Table name: comments
#
#  id               :integer(4)      not null, primary key
#  created_at       :datetime        not null
#  title            :string(255)
#  uri              :string(255)
#  blog_name        :string(255)
#  excerpt          :text(16777215)
#  user_ip          :string(15)
#  trackback        :boolean(1)
#  hide             :boolean(1)
#  commentable_type :string(24)
#  commentable_id   :integer(4)
#  sent_to_akismet  :boolean(1)
#

require 'akismet'
require 'ipaddr'

class Comment < ActiveRecord::Base

  belongs_to :commentable, :polymorphic => true, :counter_cache => true
  alias_attribute :updated_at, :created_at

  validates_presence_of :excerpt
  validates_presence_of :commentable_type
  validates_presence_of :commentable_id
  validate :valid_commentable
  validates_presence_of :user_ip
  
  before_create :spam_check
  
  attr_accessor :user_agent
  
  scope :hidden, where(:hide => true)
  scope :visible, where(:hide => false)

  def mark_as_ham
    akismet = Akismet.new(AKISMET_KEY, ROOT_URL)
    akismet.submitHam(akismet_options)
    update_attributes(:sent_to_akismet => true, :hide => false)
  end

  def mark_as_spam
    unless read_attribute(:sent_to_akismet) and read_attribute(:hide)
      begin
        akismet = Akismet.new(AKISMET_KEY, ROOT_URL)
        akismet.submitSpam(akismet_options)
      rescue SocketError, Timeout::Error, RuntimeError
        ''
      end
    end
    destroy
  end
  
  def spam_check
    bad_words = ['cialis', 'viagra', 'order soma', 'casino', 'Marvelous. Thanks, will spread this among my friends!']
    fields = ['excerpt', 'uri', 'title', 'blog_name']
    bad_words.each do |phrase|
      fields.each do |field| 
        if ! read_attribute(field).blank? and read_attribute(field).match(phrase) 
          return write_attribute(:hide, 1) 
        end
      end
    end

    akismet = Akismet.new(AKISMET_KEY, ROOT_URL)
    options = akismet_options
    options[:user_agent] = self.user_agent unless self.user_agent.nil?
    write_attribute(:sent_to_akismet, true)
    write_attribute(:hide, akismet.commentCheck(options))
    return true
  rescue SocketError, Timeout::Error, RuntimeError
    write_attribute(:sent_to_akismet, true)
    write_attribute(:hide, false)
  end

  protected
  def akismet_options
    options = {:user_ip => user_ip,
      :comment_type => 'comment',
      :comment_author => blog_name,
      :comment_content => excerpt}
    # @todo   Building the URI probably doesn't belong in the model
    options[:permalink] = "http://#{ROOT_URL}/locations/#{commentable.permalink}" if commentable.class == 'Location'
    options[:permalink] = "http://#{ROOT_URL}/stories/#{commentable.permalink}" if commentable.class == 'NewStory'
    options[:comment_author_url] = uri if ! uri.blank? and uri.match(/http:/)
    options[:comment_author_email] = uri unless uri.blank? or uri.match(/http:/)
    options[:comment_type] = 'trackback' if trackback == 1
    return options
  end
  
  def valid_commentable
    return true if self.commentable_type.constantize.find(self.commentable_id)
  rescue ActiveRecord::RecordNotFound, NoMethodError
    errors.add("commentable_id", "Must comment on a valid entry")
    return false
  end
  
end
