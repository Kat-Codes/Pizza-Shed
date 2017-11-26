Feature: Menu
    
  Scenario: Add Menu Item 
    Given I am on the add menu page
    When I fill in "pizzaname" with "Pepperoni"
    When I fill in "description" with "Double pepperoni"
    When I fill in "price" with "5.60"
    When I fill in "url" with "https://www.pizzagogo.co.uk/static/media/products/large/282.jpg"
    When I press "Submit Menu"
    Then I should be on the add menu page