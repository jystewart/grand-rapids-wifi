Given /^a location exists called "([^"]*)"$/ do |name|
  Location.create!(:name => name, :street => "Some street", :status => 'proven', :is_visible => true)
end

When /^I submit a location called "([^"]*)"$/ do |arg1|
  When %{I go to the new submission page}
  When %{I fill in "Your Name" with "James Stewart"}
  When %{I fill in "Your connection" with "Site Admin"}
  When %{I fill in "Your Email address" with "jys@ketlai.co.uk"}
  When %{I fill in "Location Name" with "My House"}
  When %{I fill in "Street Address" with "65 Auburn Ave NE"}
  When %{I fill in "ZIP code" with "49503"}
  When %{I select "proven" from "Is this a location you know to work (proven) or that you've heard may have wifi (rumored)?"}
  When %{I press "Submit Location"}
end
