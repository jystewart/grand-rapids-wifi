Feature: Submissions
  In order to keep the data fresh
  A visitor
  Should be able to submit new locations

  Scenario: Basic submission
    When I go to the new submission page
    Then show me the page
    When I fill in the following:
      | Your Name | James Stewart |
      | Your connection | Site Admin |
      | Your Email address | jys@ketlai.co.uk |
      | Location Name | My House |
      | Street Address | 65 Auburn Ave NE |
      | ZIP code | 49503 |
    And I select "proven" from "Is this a location you know to work (proven) or that you've heard may have wifi (rumored)?"
    And I press "Submit Location"
    Then show me the page
    Then I should see "Thank you for your submission."

  Scenario: Duplicate submission 
    Given a location exists called "My House"

    When I submit a location called "My House"
    Then I should see "Similar Locations"

    When I press "Submit Location"
    Then show me the page
    Then I should see "Thank you for your submission."
  
