class News < ActiveRecord::Base
  
  sends_pings

  validates_presence_of :permalink
  validates_uniqueness_of :permalink, :on => :save
  validates_presence_of :content
  validates_presence_of :headline

  belongs_to :user
  has_many :comments, :as => :commentable, :order => 'created_at ASC'
  has_many :displayable_comments, :class_name => 'Comment', 
    :as => :commentable, :conditions => 'hide = 0', :order => 'created_at ASC'
  has_many :pings, :as => :pingable, :order => 'created_at ASC'

  alias_attribute :updated_at, :created_at
  alias_attribute :title, :headline
  alias_attribute :name, :headline
  
  has_permalink :headline
  
  def author
    user.login
  end
  
  def to_param
    self.permalink
  end
end
