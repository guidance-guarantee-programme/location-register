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

  @javascript @noscript
  Scenario: Location pagination works as expected
    Given two locations exist called "Apples" and "Bamboo"
    When I visit the location directory
    And I naviagte to the "B" page
    Then I should see the "Bamboo" location

  Scenario: hidden locations are not displayed by default
    Given a hidden location exists
    When I visit the location directory
    Then I should see not see the hidden location

  @javascript @noscript
  Scenario: hidden locations can be made visible in the location directory
    Given a hidden location exists
    When I visit the location directory
    And I toggle the display hidden locations flag
    Then I should see see the hidden location

  @javascript @noscript
  Scenario: active locations can be made invisible in the location directory
    Given locations exist for my organisation
    When I visit the location directory
    And toggle the display active locations flag
    Then I should not see see the active location
    And I should see the no locations available notice

  @javascript @noscript
  Scenario: an active location can be hidden in the location directory
    Given a active location exists
    When I visit the location directory
    And I hide the active location
    Then my locations should be hidden

  @javascript @noscript
  Scenario: a hidden location can be activated in the location directory
    Given a hidden location exists
    When I visit the location directory
    And I toggle the display hidden locations flag
    And I activate the hidden location
    Then my location should be active
