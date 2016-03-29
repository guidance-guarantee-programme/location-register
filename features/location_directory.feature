Feature: Location Directory
  As a project manager
  I want to be able to see a directory listing of my CAB locations
  So that I can manage which locations are externally visible

  Scenario: Viewing locations for my organisation
    Given locations exist for my organisation
    When I visit the location directory
    Then I can see locations for my organisation

  Scenario: Viewing locations for my organisation
    Given locations exist for other organisations
    When I visit the location directory
    Then I can not see locations for other organisation

  Scenario: Location pagination works as expected
    Given that a locations exists called "Apples" and "Bamboo"
    When I visit the location directory
    And I naviagte to the "B" page
    Then I should see the "Bamboo" location

  Scenario: hidden locations are not displayed by default
    Given that a hidden location exists
    When I visit the location directory
    Then I should see not see the hidden location

  Scenario: hidden locations can be made visible in the location directory
    Given that a hidden location exists
    When I visit the location directory
    And toggle the display hidden locations flag
    Then I should see see the hidden location

  Scenario: active locations can be made invisible in the location directory
    Given locations exist for my organisation
    When I visit the location directory
    And toggle the display active locations flag
    Then I should not see see the active location
    And I should see the no locations available notice

  @javascript
  Scenario: Location pagination works as expected
    Given that a locations exists called "Apples" and "Bamboo"
    When I visit the location directory
    And I naviagte to the "B" page
    Then I should see the "Bamboo" location

  @javascript
  Scenario: hidden locations can be made visible in the location directory
    Given that a hidden location exists
    When I visit the location directory
    And toggle the display hidden locations flag
    Then I should see see the hidden location

  @javascript
  Scenario: active locations can be made invisible in the location directory
    Given locations exist for my organisation
    When I visit the location directory
    And toggle the display active locations flag
    Then I should not see see the active location
    And I should see the no locations available notice
