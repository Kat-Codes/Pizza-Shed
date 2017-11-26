Feature: Login

   Scenario: Correct Admin Login
    Given I am on the login page
    When I fill in "username" with "admin"
    When I fill in "password" with "password"
    When I press "Log In" 
    Then I should be on the admin homepage
    
  Scenario: Successful Logoff
    Given I am on the admin homepage
    When I go to the log out page
    Then I should be on the log out page
    
  Scenario: Incorrect Admin Login
    Given I am on the login page
    When I fill in "username" with "nonsense"
    When I fill in "password" with "notpassword"
    When I press "Log In" 
    Then I should be on the login page
    
  Scenario: Successful Logoff
    Given I am on the admin homepage
    When I go to the log out page
    Then I should be on the log out page
  