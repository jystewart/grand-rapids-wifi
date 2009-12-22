Feature: Sign up
  In order to limit access to protected sections of the site
  A user
  Should not be able to sign up

    Scenario: User tries to signs up with invalid data
      When I go to the sign up page
      Then I should be on the sign in page
