Feature: admin

  Scenario: Correct admin login to be able to visit the admin pages
    Given I am on the login page
    When I fill in "username" with "admin"
    When I fill in "password" with "password"
    When I press "Submit"
    Then I should see "Orders" within "nav"
    And I should see "Questions" within "nav"
    And I should see "Add Pizza" within "nav"
    And I should see "Add Account" within "nav"
    
 Scenario: Create an admin account
    Given I am on the add account page
    When I fill in "firstname" with "adminf"
    When I fill in "lastname" with "adminl"
    When I fill in "username" with "admin1"
    When I fill in "password" with "password1"
    When I fill in "email" with "admin@gmail.com"
    Then I press "signup"
    Then I should be on the add account page
    When I go to the log out page
    When I go to the log in page
    When I fill in "username" with "admin1"
    When I fill in "password" with "password1"
    When I press "log in"
    Then I should be on the admin homepage
    
  Scenario: Successful Logoff
    Given I am on the admin homepage
    When I go to the log out page
    Then I should be on the log out page
      
  Scenario: The administrator should not see the user pages
    Given I am on the login page
    When I fill in "username" with "admin"
    When I fill in "password" with "password"
    When I press "Submit"
    Then I should not see "Menu" within "nav"
    And I should not see "Our Twitter" within "nav"
    And I should not see "Sign Up" within "nav"
    And I should not see "My Account" within "nav"
    
  Scenario: Successful Logoff
    Given I am on the admin homepage
    When I go to the log out page
    Then I should be on the log out page