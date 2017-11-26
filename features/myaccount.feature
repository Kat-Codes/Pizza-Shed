Feature: MyAccount

   Scenario: Correct User Login
    Given I am on the login page
    When I fill in "username" with "shefcustomer"
    When I fill in "password" with "password"
    When I press "Log In" 
    Then I should be on the customer homepage
    Then I should see "Menu" within "nav"
    Then I should see "Our Twitter" within "nav"
    Then I should see "My Account" within "nav"
   
  Scenario: Change Details
    Given I am on the my account page
    When I fill in "username" with "shefcustomer"
    When I fill in "password" with "password"
    When I fill in "firstname" with "shef"
    When I fill in "lastname" with "shef"
    When I fill in "email" with "sheffield@sh.ac.uk"
    When I fill in "twitterhandle" with "sheff"
    When I fill in "addressline1" with "1 shef"
    When I fill in "addressline2" with "1shef"
    When I fill in "postcode" with "s1 shef"
    When I select "Sheffield" from "city" 
    When I press "Change!"
    When I go to the my account page
    Then I should see "shefcustomer"
    
     Scenario: Correct User Logout
    Given I am on the my account page
    When I go to the log out page
    Then I should be on the log out page
 