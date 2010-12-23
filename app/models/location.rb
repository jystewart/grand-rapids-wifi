# == Schema Information
#
# Table name: locations
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  street         :string(255)
#  city           :string(255)
#  state          :string(2)
#  zip            :string(10)
#  description    :text
#  url            :string(255)
#  status         :string(10)
#  visibility     :string(3)       default("no"), not null
#  created_at     :datetime        not null
#  email          :string(128)
#  permalink      :string(32)
#  ssid           :string(32)
#  free           :boolean(1)
#  phone_number   :string(20)
#  updated_at     :datetime
#  country        :string(255)
#  comments_count :integer(4)      default(0), not null
#

class Location < ActiveRecord::Base
  
  acts_as_geocodable :address => {:street => :street, :locality => :city, :region => 'MI', 
    :postal_code => :zip, :country => :country}, :normalize_address => false
    
  define_index do
    indexes name
    indexes description
    indexes street
    indexes city
    indexes :zip

    # has :zip
    has free
    has geocoding.geocode(:id), :as => :geocode_id
    has 'RADIANS(geocodes.latitude)', :as => :latitude, :type => :float
    has 'RADIANS(geocodes.longitude)', :as => :longitude, :type => :float
    
    where "is_visible = 1"
    # set_property :delta => :delayed
  end
  
  attr_accessor :distance
    
  sends_pings

  has_many :votes
  has_many :coffee_votes, :class_name => 'Vote', :conditions => 'aspect_id = 1'
  has_many :service_votes, :class_name => 'Vote', :conditions => 'aspect_id = 2'
  has_many :connection_votes, :class_name => 'Vote', :conditions => 'aspect_id = 3'
  has_many :environment_votes, :class_name => 'Vote', :conditions => 'aspect_id = 4'
  
  has_many :comments, :as => :commentable, :order => 'created_at ASC'
  has_many :displayable_comments, :class_name => 'Comment', 
    :as => :commentable, :conditions => 'hide = 0', :order => 'created_at ASC'
  has_many :pings, :as => :pingable, :order => 'created_at ASC'
  has_many :openings, :order => 'opening_day'
  accepts_nested_attributes_for :openings, :allow_destroy => true, 
    :reject_if => proc { |attrs| attrs['opening_day'].blank? or (attrs['opening_time(4i)'] == attrs['closing_time(4i)'] and attrs['opening_time(5i)'] == attrs['closing_time(5i)']) }

  has_and_belongs_to_many :neighbourhoods
  accepts_nested_attributes_for :neighbourhoods

  validates_presence_of :name
  validates_presence_of :status
  validates_presence_of :street
  validates :zip, :presence => true, :format => /\d{5}/

  validates_inclusion_of :status, :in => %w(rumored proven closed)
  
  scope :zip_codes, group('zip').select('zip').order('zip').where(['zip IS NOT NULL AND is_visible = ?', true])
  scope :to_list, where(:is_visible => true, :status => %W(proven rumoured)).order('name')
  scope :latest_visible, limit(3).where(:status => 'proven', :is_visible => true).order('updated_at DESC')
  scope :visible, where(:is_visible => true)
  scope :active, where(:status => ['proven', 'rumored'])

  scope :for_widgets, select('name, permalink, comments_count').group('name')
  scope :least_comments, proc { |the_limit| order('comments_count ASC').limit(the_limit) }
  scope :most_comments, proc { |the_limit| order('comments_count DESC').limit(the_limit) }
  scope :open_now, proc { visible.includes(:openings).where(['? BETWEEN openings.opening_time AND openings.closing_time AND 
    ? BETWEEN openings.opening_day AND openings.closing_day', Time.now.strftime('%H:%M'), Time.now.wday]) }

  default_scope order('name')
  delegate :latitude, :to => :geocode
  delegate :longitude, :to => :geocode
  
  alias_attribute :title, :name
  
  has_friendly_id :name, :use_slug => true, :cache_column => 'permalink'

  def neighbourhoods=(n_list)
    neighbourhoods.clear
    n_list.each do |neighbourhood|
      self.neighbourhoods << Neighbourhood.find(neighbourhood)
    end
  rescue
    return
  end

  def full_address
    parts = [self.street, self.zip, 'USA']
    parts.compact.join(", ")
  end
  
  class <<self
    def recent_comments(the_limit = 5)
      find_by_sql(['SELECT locations.id, locations.name, comments.blog_name AS blog_name, permalink
      FROM comments,locations
      WHERE
        comments.commentable_type = \'Location\' AND
        comments.commentable_id = locations.id AND
        comments.hide != 1
      GROUP BY locations.id
      ORDER BY comments.created_at DESC, comments.id DESC LIMIT ?', the_limit])
    end

    def highly_rated(limit = 5)
      find_by_sql(['SELECT locations.permalink, locations.name, locations.id AS id,
          SUM(rating)/COUNT(rating) AS average, COUNT(rating) AS votes
        FROM locations, votes
        WHERE 
          votes.location_id = locations.id
        GROUP BY votes.location_id 
        HAVING votes > 7
        ORDER BY average DESC LIMIT ?', limit])
    end

    def find_similar(name)
      find_by_sql(["SELECT MATCH (name, street) AGAINST (?) AS relevance, locations.*
      FROM
        locations
      WHERE
        MATCH(name, street) AGAINST (?) OR
        SUBSTRING(name, 1, 5) SOUNDS LIKE SUBSTRING(?, 1 ,5)
      ORDER BY relevance DESC
      LIMIT 5", name, name, name])
    end
  end
end
