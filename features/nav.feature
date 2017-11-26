Feature: Navigation

  Scenario: Navigate to the Homepage
    Given I am on the menu page
    When I follow "Home" within "nav"
    Then I should be on the homepage
  
  Scenario: Navigate to Menu
    Given I am on the homepage
    When I follow "Menu" within "nav"
    Then I should be on the menu page
    
  Scenario: Navigate to Twitter
    Given I am on the homepage
    When I follow "Our Twitter" within "nav"
    Then I should be on the twitter page
    
  Scenario: Navigate to the Signup page
    Given I am on the homepage
    When I follow "Sign Up" within "nav"
    Then I should be on the signup page
    
  Scenario: Navigate to the login page
    Given I am on the homepage
    When I follow "Log In" within "nav"
    Then I should be on the login page
