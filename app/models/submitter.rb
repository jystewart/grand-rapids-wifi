require 'email_validator'

class Submitter
  include ActiveModel::Validations
  
  attr_accessor :name, :connection, :email
  validates :name, :presence => true
  validates :email, :presence => true, :email => true

  def initialize(args = {})
    args.each do |k, v|
      send("#{k}=", v)
    end
  end

  def persisted?
    false
  end
end