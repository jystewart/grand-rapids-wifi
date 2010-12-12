Feature: Administrator Sign in
  In order to get access to protected sections of the site
  An administrator
  Should be able to sign in

  Scenario: Administrator is not signed up
    Given no administrator exists with an email of "email@person.com"
    When I go to the administrator sign in page
    And I sign in as administrator "email@person.com/password"
    Then I should see "Invalid email or password"
    And I should not be signed in as a administrator 

  Scenario: Administrator enters wrong password
    Given I signed up as a administrator with "email@person.com/password"
    When I go to the administrator sign in page
    And I sign in as administrator "email@person.com/wrongpassword"
    Then I should see "Invalid email or password"
    And I should not be signed in as a administrator

  Scenario: Administrator signs in successfully
    Given I signed up as a administrator with "email@person.com/password"
    When I go to the administrator sign in page
    And I sign in as administrator "email@person.com/password"

    Then I should see "Signed in"
    And I should be signed in as a administrator
