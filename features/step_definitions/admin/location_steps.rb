Given(/^a location exists for my organisation$/) do
  create(:user, :project_manager, :nicab)
  @location = create(:location, :nicab)
end

When(/^I visit the locations admin page$/) do
  @page = AdminLocationPage.new
  @page.load(uid: @location.uid)
end

Then(/^I can see the locations details$/) do
  expect(@page).to have_location_title
  expect(@page).to have_address
  expect(@page).to have_booking_hours
  expect(@page).to have_telephone_number
  expect(@page).to have_visibility
end

Given(/^a location exist for another organisations$/) do
  create(:user, :project_manager, :nicab)
  @location = create(:location, :cas)
end

Then(/^no location exists to view$/) do
  expect(@page).not_to be_loaded
end

When(/^I visit the "([^"]*)" location$/) do |location_title|
  @location = Location.find_by(title: location_title)
  @page = AdminLocationPage.new
  @page.load(uid: @location.uid)
end

When(/^I (.*) the locations "([^"]*)" field to "([^"]*)"$/) do |method, field, new_value|
  @page.edit_button.click
  edit_page = AdminEditLocationPage.new
  element = edit_page.public_send(field)
  element.public_send(method, new_value)
  edit_page.save_button.click
end

Then(/^the "([^"]*)" location has a new version where "([^"]*)" has been set to "([^"]*)"$/) do |title, field, value|
  previous_location, current_location = *LocationTestHelper.get_all_location_versions(title: title)

  edited_fields = EditedLocation.new([current_location, previous_location]).edits.values.flatten
  expect(edited_fields).to equal_edits(
    [{ field: LocationTestHelper.field_name(field), new_value: LocationTestHelper.field_value(field, value) }]
  )
end

Then(/^the "([^"]*)" location address has been updated to have "([^"]*)" set to "([^"]*)"$/) do |title, _field, value|
  previous_location, current_location = *LocationTestHelper.get_all_location_versions(title: title)

  edited_fields = EditedLocation.new([current_location, previous_location]).edits.values.flatten
  expect(edited_fields).to match_edits([{ field: 'address', new_value: value }])
end

Then(/^I should see an error message for "([^"]*)"$/) do |field|
  edit_page = AdminEditLocationPage.new
  expect(edit_page.error_messages.first).to match(field)
end

When(/^I add a guider$/) do
  AdminGuiderPage.new.tap do |guider_page|
    guider_page.load(location_id: @location.uid)

    guider_page.name.set 'Ben Lovell'
    guider_page.email.set 'ben@example.com'
    guider_page.add.click
  end
end

Then(/^the guider is added$/) do
  AdminGuiderPage.new.tap do |guider_page|
    expect(guider_page).to be_displayed
    expect(guider_page).to have_guiders(count: 1)

    expect(guider_page.guiders.first.name.text).to eq('Ben Lovell')
    expect(guider_page.guiders.first.email.text).to eq('ben@example.com')
  end
end

module LocationTestHelper
  FIELD_NAME_MAP = {
    'location_title' => 'title',
    'booking_hours' => 'hours',
    'make_location_visible' => 'visibility'
  }.freeze

  module_function

  def get_all_location_versions(query)
    location_uid = Location.find_by(query).uid
    Location.where(uid: location_uid).order(:version)
  end

  def field_name(field)
    FIELD_NAME_MAP[field] || field
  end

  def field_value(field, value)
    return value unless field == 'make_location_visible'
    value == 'No' ? 'Hidden' : 'Active'
  end
end
