Feature: Create a new location

  @vcr
  Scenario: Creating a location as a project manager
    When I create a new booking location
    Then the location is created
    And the location is hidden

  @vcr
  Scenario: Creating a location as a pensionwise admin
    Given I am a pensionwise admin
    When I create a new booking location with a twilio number
    Then the location is created
    And the location is visible
