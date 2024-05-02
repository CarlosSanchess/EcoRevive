Feature: Add Product

  Scenario: User adds a new product
    Given I am on the Home page
    When I select the + icon, to add a new product
    And I fill the
    And I fill in the review form with a rating of 4.5 stars and feedback "Great product!"
    And I submit the review
    Then I should see a confirmation message "Review submitted successfully"
