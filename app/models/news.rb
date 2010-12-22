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

  has_friendly_id :headline, :use_slug => true, :cache_column => 'permalink'
  
  def author
    administrator.to_s
  end
  
  class <<self
    def archives
      months = find_by_sql('SELECT DISTINCT concat(year(created_at), \'-\', month(created_at)) as month FROM news ORDER BY month DESC')
      months.collect do |date|
        dates = date.month.split('-')
        {
          :name => Date::MONTHNAMES[dates[1].to_i] + ' ' + dates[0], 
          :year => dates[0],
          :month => sprintf('%02d', dates[1])
        }
      end
    end
  end
end
