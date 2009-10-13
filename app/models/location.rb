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
    
    where "visibility = \'yes\'"
    set_property :delta => :delayed
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
  accepts_nested_attributes_for :openings, :allow_destroy => true, :reject_if => proc { |attrs| attrs['opening_day'].blank? }

  has_and_belongs_to_many :neighbourhoods
  accepts_nested_attributes_for :neighbourhoods

  validates_presence_of :name
  validates_presence_of :status
  validates_presence_of :street
  validates_format_of :zip, :with => /\d{5}/, :if => Proc.new { |l| l.country == 'USA' }
  validates_uniqueness_of :permalink, :on => :save
  validates_inclusion_of :visibility, :in => %w( yes no ), :allow_nil => false
  validates_inclusion_of :status, :in => %w(rumored proven closed)
  
  named_scope :zip_codes, :group => 'zip', :select => 'zip', :order => 'zip', :conditions => ['zip IS NOT NULL AND visibility = ?', 'yes']
  delegate :latitude, :to => :geocode
  delegate :longitude, :to => :geocode
  
  alias_attribute :title, :name
  
  has_permalink :name

  def neighbourhoods=(n_list)
    neighbourhoods.clear
    n_list.each do |neighbourhood|
      self.neighbourhoods << Neighbourhood.find(neighbourhood)
    end
  rescue
    return
  end

  class <<self
    def open_now
      all(:include => :openings, :conditions => 
        ['visibility = ? AND ? BETWEEN openings.opening_time AND openings.closing_time AND 
        ? BETWEEN openings.opening_day AND openings.closing_day', 
        'yes', Time.now.strftime('%H:%M'), Time.now.wday])
    end

    def recent_comments(limit = 5)
      find_by_sql(['SELECT locations.id, locations.name, comments.blog_name AS blog_name, permalink
      FROM comments,locations
      WHERE
        comments.commentable_type = \'Location\' AND
        comments.commentable_id = locations.id AND
        comments.hide != 1
      GROUP BY locations.id
      ORDER BY comments.created_at DESC, comments.id DESC LIMIT ?', limit])
    end

    def most_comments(limit = 5)
      all(:select => 'name, permalink, comments_count', :order => 'comments_count DESC', :limit => limit, :group => 'name')
    end

    def least_comments(limit = 5)
      all(:select => 'name, permalink, comments_count', :order => 'comments_count ASC', :limit => limit, :group => 'name')
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

  def to_param
    self.permalink || self.name.parameterize.to_s
  end
end
