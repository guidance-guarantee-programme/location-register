Feature: Admin - Location Directory
  As a project manager
  I want to be able to view and edit my CAB locations
  So that I can manage the location setup

  Scenario: Viewing a locations details for my organisation as a project manager
    Given a location exists for my organisation
    When I visit the locations admin page
    Then I can see the locations details

  Scenario Outline: Editing a locations creates a new version with the updated values
    Given a location exists called "Apples"
    When I visit the "Apples" location
    And I <method> the locations "<Field>" field to "<Value>"
    Then the "Apples" location has a new version where "<Field>" has been set to "<Value>"

    Examples:
      | method | Field                 | Value                  |
      | set    | location_title        | Super Location         |
      | set    | booking_hours         | Mon to Fri 6am to 1pm  |
      | choose | make_location_visible | No                     |

  Scenario: Editing a locations booking location creates a new version with the updated values
    Given two locations exist called "Apples" and "Bamboo"
    When I visit the "Apples" location
    And I select the locations "booking_location" field to "Bamboo"
    Then the "Apples" location has a new version where "booking_location" has been set to "Bamboo"

  @vcr
  Scenario Outline: Editing a locations address creates a new version with the updated values
    Given a location exists called "Apples"
    When I visit the "Apples" location
    And I <method> the locations "<Field>" field to "<Value>"
    Then the "Apples" location address has been updated to have "<Field>" set to "<Value>"

    Examples:
      | method | Field            | Value                  |
      | set    | address_line_1   | Flat 3                 |
      | set    | address_line_2   | 30 Test Road           |
      | set    | address_line_2   | Back of beyond         |
      | set    | town             | Test vale              |
      | set    | county           | Testland               |
      | set    | postcode         | PR1 2NJ                |
      | set    | postcode         | LA6 2BG                |

  Scenario: A new location version is created when the location is edited
    Given a location exists called "Apples"
    When I visit the "Apples" location
    And I set the locations "location_title" field to "Green delicious"
    Then I see that the location has a newer version

  Scenario: When an update fails
    Given a location exists called "Apples"
    When I visit the "Apples" location
    And I set the locations "postcode" field to ""
    Then I should see an error message for "postcode"

  Scenario: I can make a location with a twilio number visible
    Given a hidden location exists with a twilio number
    When I toggle the location's visibility
    Then the location is visible

  Scenario: I can not make a location without a twilio number visible
    Given a hidden location exists without a twilio number
    When I toggle the location's visibility
    Then I get a permission denied error
    And the location is hidden

  Scenario: Adding guiders for an online booking location
    Given a location exists called "London"
    When I visit the "London" location
    And I add a guider
    Then the guider is added
    When I hide the guider
    Then the guider is hidden
    When I unhide the guider
    Then the guider is visible
