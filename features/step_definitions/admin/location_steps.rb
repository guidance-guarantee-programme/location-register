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
  expect(@page).to have_address_line_1
  expect(@page).to have_address_line_2
  expect(@page).to have_address_line_3
  expect(@page).to have_booking_hours
  expect(@page).to have_telephone_number
  expect(@page).to have_hidden_false
  expect(@page).to have_hidden_true
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
  element = @page.public_send(field)
  element.public_send(method, new_value)
  @page.save_button.click
end

Then(/^the "([^"]*)" location has the field "([^"]*)" set to "([^"]*)"$/) do |title, field, value|
  location = Location.find_by(title: title)
  field_value = location.send(field)
  field_value = field_value.title if field_value.is_a?(Location)

  expect(field_value).to eq value
end

Then(/^I should see an error message for "([^"]*)"$/) do |field|
  edit_page = AdminLocationPage.new
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

  def field_name(field)
    FIELD_NAME_MAP[field] || field
  end

  def field_value(field, value)
    return value unless field == 'make_location_visible'
    value == 'No' ? 'Hidden' : 'Active'
  end
end
