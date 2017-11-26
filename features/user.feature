Feature: user
  
  Scenario: Correct User Login
    Given I am on the login page
    When I fill in "username" with "shefcustomer"
    When I fill in "password" with "password"
    When I press "Log In" 
    Then I should be on the customer homepage
    Then I should see "Menu" within "nav"
    Then I should see "Our Twitter" within "nav"
    Then I should see "My Account" within "nav"
    Then I should not see "Admin Home" within "nav"
    Then I should not see "Orders" within "nav"
    Then I should not see "Questions" within "nav"
    Then I should not see "Add Pizza" within "nav"
    Then I should not see "Add Account" within "nav"
  
  Scenario: Correct User Logout
    Given I am on the my account page
    When I go to the log out page
    Then I should be on the log out page