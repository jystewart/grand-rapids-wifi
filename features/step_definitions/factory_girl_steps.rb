FactoryBot.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :administrator do |user|
    user.email                 { FactoryBot.next :email }
    user.password              { "password" }
    user.password_confirmation { "password" }
  end
end

FactoryBot.factories.each do |name, factory|
  Given /^an? #{name} exists with an? (.*) of "([^"]*)"$/ do |attr, value|
    FactoryBot.create(name, attr.gsub(' ', '_') => value)
  end
end
