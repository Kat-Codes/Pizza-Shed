Feature: signup

  Scenario: Correct user information entered
    Given I am on the signup page
    When I fill in "firstname" with "Lawrence"
    When I fill in "lastname" with "schobs"
    When I fill in "twitterhandle" with "LawrenceSchobs"
    When I fill in "username" with "lawrence1"
    When I fill in "password" with "password"
    When I fill in "email" with "laschobs1@sheffield.ac.uk"
    When I fill in "addressline1" with "flat 21"
    When I fill in "addressline2" with "160 broad lane"
    When I fill in "postcode" with "s1 4bu"
    When I select "Sheffield" from "city" 
    When I press "Sign Up"
    Then I should be on the signup page
    When I go to the login page
    When I fill in "username" with "lawrence1"
    When I fill in "password" with "password"
    When I press "Log In" 
    Then I should be on the customer homepage
    When I go to the log out page
    Then I should be on the log out page
    
  Scenario: Incorrect email entered
    Given I am on the signup page
    When I fill in "firstname" with "Lawrence"
    When I fill in "lastname" with "schobs"
    When I fill in "twitterhandle" with "LawrenceSchobs"
    When I fill in "username" with "lawrence1"
    When I fill in "password" with "password"
    When I fill in "email" with "laschobs1sheffield.ac.uk"
    When I fill in "addressline1" with "flat 21"
    When I fill in "addressline2" with "160 broad lane"
    When I fill in "postcode" with "s1 4bu"
    When I select "Sheffield" from "city" 
    When I press "Sign Up"
    Then I should be on the signup page
    Then I should see "Please include an '@'"
   
