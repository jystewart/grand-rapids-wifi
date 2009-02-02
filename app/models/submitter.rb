class Submitter < ActiveForm
  attr_accessor :name, :connection, :email
  validates_presence_of :name
  validates_presence_of :email
  validates_format_of :email, :with => /^[-^!$#%&'*+\/=?`{|}~.\w]+
    @[a-zA-Z0-9]([-a-zA-Z0-9]*[a-zA-Z0-9])*
    (\.[a-zA-Z0-9]([-a-zA-Z0-9]*[a-zA-Z0-9])*)+$/x,
    :message => 'Please specify a valid email address'

end