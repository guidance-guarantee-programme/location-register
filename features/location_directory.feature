Feature: Location Directory
  As a project manager
  I want to be able to see a directory listing of my CAB locations
  So that I can manage which locations are externally visible

  Scenario: Viewing locations for my organisation
    Given locations exist for my organisation
    When I visit the location directory
    Then I can see locations for my organisation

  @wip
  Scenario: Viewing locations for my organisation
    Given locations exist for other organisations
    When I visit the location directory
    Then I can not see locations for other organisation
