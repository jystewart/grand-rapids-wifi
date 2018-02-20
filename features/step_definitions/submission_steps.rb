Given /^a location exists called "([^"]*)"$/ do |name|
  l = Location.create!(name: name, street: "Some street", status: 'proven', zip: '49503')
  l.is_visible = true
  l.save!
end

When /^I submit a location called "([^"]*)"$/ do |arg1|
  step %{I go to the new submission page}
  step %{I fill in "Your Name" with "James Stewart"}
  step %{I fill in "Your connection" with "Site Admin"}
  step %{I fill in "Your Email address" with "jys@ketlai.co.uk"}
  step %{I fill in "Location Name" with "My House"}
  step %{I fill in "Street Address" with "65 Auburn Ave NE"}
  step %{I fill in "ZIP code" with "49503"}
  step %{I select "proven" from "Is this a location you know to work (proven) or that you've heard may have wifi (rumored)?"}
  step %{I press "Submit Location"}
end
