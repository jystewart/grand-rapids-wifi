Given /^no (.+?) exists with an email of "(.*)"$/ do |authenticable, email|
  assert_nil authenticable.camelize.constantize.find_by_email(email)
end

Given /^I signed up as an? (.+?) with "(.*)\/(.*)"$/ do |authenticable, email, password|
  @user = FactoryBot.create authenticable.to_sym,
    :email                 => email,
    :password              => password,
    :password_confirmation => password
end

Given /^I am signed up and confirmed as (.+?) "(.*)\/(.*)"$/ do |authenticable, email, password|
  step %{I signed up as a #{authenticable} with "#{email}/#{password}"}
  @user.confirm! if @user.respond_to?(:confirm!)
end

Given /^I am signed in as the (.+?) with credentials "(.*)\/(.*)"$/ do |authenticable, email, password|
  step %{I am signed up and confirmed as #{authenticable} "#{email}/#{password}"}
  sign_in_step = "I sign in as #{authenticable} \"#{email}/#{password}\""
  step sign_in_step
end

Given /^I requested a new password for the (.+?) with email "(.*?)"$/ do |authenticable, email|
  step %{I go to the #{authenticable} new password page}
  step %{I fill in "Email" with "#{email}"}
  step %{I press "Send me reset password instructions"}
end

When /^I sign in( with "remember me")? as (.+?) "(.*)\/(.*)"$/ do |remember, authenticable, email, password|
  step %{I go to the #{authenticable} sign in page}
  step %{I fill in "Email" with "#{email}"}
  step %{I fill in "Password" with "#{password}"}
  step %{I check "Remember me"} if remember
  step %{I press "Sign in"}
end

Then /^I should not be signed in as a (.+?)$/ do |authenticable|
  visit admin_path
  expect(page).to have_content("You need to sign in or sign up before continuing")
end

Then /^I should be signed in as a (.+?)$/ do |authenticable|
  login_path = send("new_#{authenticable}_session_path")
  logout_path = send("destroy_#{authenticable}_session_path")
  visit admin_path
  expect(page).to_not have_css("a[href='#{login_path}']")
  expect(page).to have_css("a[href='#{logout_path}']")
end

# This isn't a very good way to test this but capybara's abstraction
# means I can't directly clear the session
When /^I return next time$/ do
  step %{I go to the homepage}
end

When /^I follow the link in the password reset email for (.+?) "([^\"]*)"$/ do |authenticable, email|
  user = authenticable.camelize.constantize.find_by_email(email)
  method = "edit_#{authenticable}_password_path"
  visit send(method, :reset_password_token => user.reset_password_token)
end

Then /^I should see error messages$/ do
  page.should have_css('#errorExplanation')
end

When /^I follow the confirmation link sent to (.+?) "([^\"]*)"$/ do |authenticable, email|
  user = authenticable.camelize.constantize.find_by_email(email)
  method = "#{authenticable}_confirmation_path"
  visit send(method, :confirmation_token => user.confirmation_token)
end

Then /^a confirmation message should be sent to (.+?) "([^\"]*)"$/ do |authenticable, email|
  user = authenticable.camelize.constantize.find_by_email(email)
  sent = ActionMailer::Base.deliveries.last
  assert_equal [email], sent.to
  assert_match /Activate your account now/i, sent.subject
  assert !user.confirmation_token.blank?

  if sent.parts.size == 1
    text_component = sent.body
  else
    text_component = sent.parts.find { |p| p.content_type.match("text/plain") }.body.to_s
  end

  assert_match /#{user.confirmation_token}/, text_component
end

Then /^a password reset email should be sent to (.+?) "([^\"]*)"$/ do |authenticable, email|
  sent = ActionMailer::Base.deliveries.last
  assert_equal [email], sent.to
  assert_match /Reset password instructions/i, sent.subject
end

Then /^the password for (.+?) "([^\"]*)" should be "([^\"]*)"$/ do |authenticable, email, password|
  user = authenticable.camelize.constantize.find_by_email(email)
  user.valid_password?(password)
end
