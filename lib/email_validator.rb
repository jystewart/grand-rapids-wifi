# lib/email_validator.rb
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ Devise.email_regexp
      record.errors[attribute] << (options[:message] || "is not valid")
    end
  end

end
