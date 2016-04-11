Feature: Admin - List of edited locations
  As a pension wise admin
  I need to be able to see a list of edited locations
  So that I can take appropriate actions

  Scenario: Location has been hidden
    Given a location exists that has been hidden
    When I view the edited locations page
    Then I should see a location with the following edits:
      | Field      | Old value | New value |
      | Visibility | Active    | Hidden    |

  Scenario: Location has multiple edits during the day
    Given a location exists that has been hidden and then made visible
    When I view the edited locations page
    Then I should see a location with the following edits:
      | Field      | Old value | New value |
      | Visibility | Active    | Hidden    |
      | Visibility | Hidden    | Active    |

  Scenario: Location with edits on other days
    Given a location exists that was hidden yesterday
    When I view the edited locations page
    And I navigate to the previous day
    Then I should see a location with the following edits:
      | Field      | Old value | New value |
      | Visibility | Active    | Hidden    |

  Scenario: Location address is edited
    Given a location exists that with a address edit
    When I view the edited locations page
    Then I should see a location with the following edits:
      | Field      | Old value        | New value      |
      | Address    | One line address | My New Address |

  Scenario: Navigating to a specific locations page
    Given a location exists that with a address edit
    When I view the edited locations page
    And I click on the location
    Then I am on the locations page
