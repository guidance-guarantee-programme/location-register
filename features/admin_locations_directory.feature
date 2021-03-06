Feature: Admin - Location Directory
  As a project manager
  I want to be able to see a directory listing of my CAB locations
  So that I can manage which locations are externally visible

  Scenario: Locations for their organisation should be visible to project managers
    Given locations exist for my organisation
    When I visit the locations admin directory
    Then I can see locations for my organisation

  Scenario: Locations for other organisation should not be visible to project managers
    Given locations exist for other organisations
    When I visit the locations admin directory
    Then I can not see locations for other organisation

  @javascript @noscript
  Scenario: Location pagination works as expected
    Given two locations exist called "Apples" and "Bamboo"
    When I visit the locations admin directory
    And I navigate to the "B" page
    Then I should see the "Bamboo" location

  Scenario: Hidden locations are not displayed by default
    Given a hidden location exists
    When I visit the locations admin directory
    Then I should see not see the hidden location

  @javascript @noscript
  Scenario: Hidden locations can be made visible in the location directory
    Given a hidden location exists
    When I visit the locations admin directory
    And I toggle the display hidden locations flag
    Then I should see see the hidden location

  @javascript @noscript
  Scenario: Active locations can be made invisible in the location directory
    Given locations exist for my organisation
    When I visit the locations admin directory
    And toggle the display active locations flag
    Then I should not see see the active location
    And I should see the no locations available notice

  Scenario: Navigating to a specific locations page
    Given an active location exists
    When I visit the locations admin directory
    And I click on the location edit button
    Then I am on the locations page

  Scenario: Exporting locations in CSV format
    Given an active location exists
    When I visit the locations admin directory
    And I export the results to CSV
    Then I am prompted to download the CSV
