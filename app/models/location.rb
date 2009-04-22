class Location < ActiveRecord::Base
  attr_accessor :distance
  acts_as_geocodable :address => {:street => :street, :locality => :city, :region => 'MI', 
    :postal_code => :zip, :country => :country}, :normalize_address => false
    
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
  has_and_belongs_to_many :neighbourhoods

  validates_presence_of :name
  validates_presence_of :status
  validates_presence_of :street
  validates_format_of :zip, :with => /\d{5}/, :if => Proc.new { |l| l.country == 'USA' }
  validates_uniqueness_of :permalink, :on => :save
  validates_inclusion_of :visibility, :in => %w( yes no ), :allow_nil => false
  validates_inclusion_of :status, :in => %w(rumored proven closed)
  
  delegate :latitude, :to => :geocode
  delegate :longitude, :to => :geocode
  
  alias_attribute :title, :name
  
  has_permalink :name
  
  def openings=(opening_list)
    openings.delete_all
    opening_list.each do |key, new_opening|
      if new_opening['opening_hour'] and new_opening['opening_minute'] and new_opening['closing_hour'] and new_opening['closing_minute']
        new_opening['opening_time'] = new_opening.delete('opening_hour') + ':' + new_opening.delete('opening_minute') + ':00'
        new_opening['closing_time'] = new_opening.delete('closing_hour') + ':' + new_opening.delete('closing_minute') + ':00'
      end
      self.openings.build(new_opening)
    end
  end
  
  def neighbourhoods=(n_list)
    neighbourhoods.clear
    n_list.each do |neighbourhood|
      self.neighbourhoods << Neighbourhood.find(neighbourhood)
    end
  rescue
    return
  end

  def self.search(location = HashWithIndifferentAccess.new, date = nil, keywords = nil)
    options = { :group => 'locations.id' }
    cond = Caboose::EZ::Condition.new
    cond << ['visibility = ?', 'yes']
    cond << ['zip = ?', location[:zip]] unless location[:zip].blank?
    cond << 'free = 1' if location[:free] == 1
    
    if keywords.is_a?(String)
      cond << ['description LIKE ?', '%' + keywords + '%']
    elsif keywords.is_a?(Array)
      keywords[0].split(' ').each { |keyword| cond << ['description LIKE ?', '%' + keyword + '%'] }
    end

    days = %w(monday tuesday wednesday thursday friday saturday sunday)
    if date.is_a?(Hash) and days.include?(date['day'])
      options[:include] ||= []
      options[:include] << :openings
      
      day_index = days.index(date['day']) + 1
      time = date['hour'].to_s + ':' + date['minute'].to_s + ':00'

      cond << ['? BETWEEN openings.opening_day and openings.closing_day', day_index]
      cond << ['? BETWEEN openings.opening_time AND openings.closing_time', time]
    end

    options[:conditions] = cond.to_sql
    
    unless location[:address].blank?
      options[:origin] = location[:address]
      options[:order] = 'distance ASC'
    end
    
    @locations = find(:all, options)
  end

  def self.open_now
    find(:all, :include => :openings, :conditions => 
      ['visibility = ? AND ? BETWEEN openings.opening_time AND openings.closing_time AND 
      ? BETWEEN openings.opening_day AND openings.closing_day', 
      'yes', Time.now.strftime('%H:%M'), Time.now.wday])
  end

  def self.recent_comments(limit = 5)
    self.find_by_sql(['SELECT
      locations.id,
      locations.name,
      comments.blog_name AS blog_name,
      permalink
    FROM comments,locations
    WHERE
      comments.commentable_type = \'Location\' AND
      comments.commentable_id = locations.id AND
      comments.hide != 1
    GROUP BY locations.id
    ORDER BY comments.created_at DESC, comments.id DESC LIMIT ?', limit])
  end

  def self.most_comments(limit = 5)
    self.find_by_sql(['SELECT locations.name,
      locations.permalink,
      COUNT(comments.id) AS comments
    FROM locations LEFT JOIN comments
    ON locations.id = comments.commentable_id
    WHERE comments.commentable_type = \'Location\'
    GROUP BY name
    ORDER BY comments DESC LIMIT ?', limit])
  end

  def self.least_comments(limit = 5)
    self.find_by_sql(['SELECT locations.name,
      locations.permalink,
      COUNT(comments.id) AS comments
    FROM locations LEFT JOIN comments
    ON locations.id = comments.commentable_id
    GROUP BY name
    ORDER BY comments ASC LIMIT ?', limit])
  end

  def self.highly_rated(limit = 5)
    self.find_by_sql(['SELECT 
        locations.permalink,
        locations.name,
        locations.id AS id,
        SUM(rating)/COUNT(rating) AS average,
        COUNT(rating) AS votes
      FROM locations, votes
      WHERE 
        votes.location_id = locations.id
      GROUP BY votes.location_id 
      HAVING votes > 7
      ORDER BY average DESC LIMIT ?', limit])
  end

  def self.find_similar(name)
    self.find_by_sql(["SELECT
        MATCH (name, street) AGAINST (?) AS relevance,
        locations.*
    FROM
      locations
    WHERE
      MATCH(name, street) AGAINST (?) OR
      SUBSTRING(name, 1, 5) SOUNDS LIKE SUBSTRING(?, 1 ,5)
    ORDER BY relevance DESC
    LIMIT 5", name, name, name])
  end

  def to_param
    self.permalink
  end
end
