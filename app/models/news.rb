# == Schema Information
#
# Table name: news
#
#  id             :integer(4)      not null, primary key
#  headline       :string(255)
#  content        :text(16777215)
#  external       :string(255)
#  created_at     :datetime
#  extended       :text(16777215)
#  permalink      :string(32)
#  user_id        :integer(4)
#  comments_count :integer(4)      default(0), not null
#

class News < ActiveRecord::Base
  
  sends_pings

  validates_presence_of :permalink
  validates_uniqueness_of :permalink, :on => :save
  validates_presence_of :content
  validates_presence_of :headline

  belongs_to :administrator
  has_many :comments, :as => :commentable, :order => 'created_at ASC'
  has_many :displayable_comments, :class_name => 'Comment', 
    :as => :commentable, :conditions => 'hide = 0', :order => 'created_at ASC'
  has_many :pings, :as => :pingable, :order => 'created_at ASC'

  alias_attribute :updated_at, :created_at
  alias_attribute :title, :headline
  alias_attribute :name, :headline

  scope :between, proc { |start, finish| where('created_at BETWEEN ? AND ?', start, finish) }
  default_scope order('created_at DESC')

  has_permalink :headline
  
  def author
    administrator.to_s
  end
  
  def to_param
    self.permalink
  end
end
