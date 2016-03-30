Feature: Locations JSON
  As a locations data user
  I want to be able to retrieve locations data in JSON format

  Scenario: Retrieve locations JSON
    When I retrieve locations data
    Then I receive a JSON response
