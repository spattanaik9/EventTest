Feature: Event manager creates an event
  
  Scenario: verify user is able to create event successfully
    
    Given: I am on events page
    When I click on add event
    And I fill in "Name" with "Event-1"
    And I fill in "Date and Time" with "04/08/2023 2:00 PM"
    And I click on "Create"
    Then an event should be created successfully
    