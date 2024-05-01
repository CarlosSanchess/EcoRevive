Feature: User Rating Feedback

  Scenario: User rates their experience with another user
    Given I am on the Home page
    When I select a product
    And I press the "Leave a Review" button
    And I fill in the review form with a rating of 4.5 stars and feedback "Great product!"
    And I submit the review
    Then I should see a confirmation message "Review submitted successfully"
