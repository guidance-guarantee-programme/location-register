Given(/^locations exist for my organisation$/) do
  create(:user, :project_manager, :nicab)
  create(:location, :nicab)
  create(:location, :nicab)
end

When(/^I visit the locations admin directory$/) do
  @page = AdminLocationDirectoryPage.new
  @page.load
end

Then(/^I can see locations for my organisation$/) do
  expect(@page.locations.size).to eq(2)

  @page.locations.each do |location|
    expect(location).to have_location_title
    expect(location).to have_address
    expect(location).to have_booking_hours
    expect(location).to have_telephone_number
    expect(location).to have_visibility
  end
end

Given(/^locations exist for other organisations$/) do
  create(:user, :project_manager, :nicab)
  create(:location, :cas)
  create(:location, :citi)
  @nicab_location = create(:location, :nicab)
end

Then(/^I can not see locations for other organisation$/) do
  expect(@page.locations.size).to eq(1)

  expect(@page.locations[0].location_title.text).to eq(@nicab_location.title)
end

Given(/^two locations exist called "([^"]*)" and "([^"]*)"$/) do |title1, title2|
  create(:user, :project_manager, :nicab)
  create(:location, :nicab, title: title1)
  create(:location, :nicab, title: title2)
end

Given(/^a location exists called "([^"]*)"$/) do |title|
  create(:user, :project_manager, :nicab)
  create(:location, :nicab, title: title)
end

When(/^I naviagte to the "([^"]*)" page$/) do |letter|
  @page.navigate_to(letter)
end

Then(/^I should see the "([^"]*)" location$/) do |title|
  expect(@page.locations.count).to eq(1)
  expect(@page.locations[0].location_title.text).to eq(title)
end

Given(/^a hidden location exists$/) do
  create(:user, :project_manager, :nicab)
  create(:location, :nicab, hidden: true)
end

Then(/^I should see not see the hidden location$/) do
  expect(@page.locations.count).to eq(0)
end

When(/^I toggle the display hidden locations flag$/) do
  @page.display_hidden_locations
end

Then(/^I should see see the hidden location$/) do
  expect(@page.locations.count).to eq(1)
  expect(@page.locations[0].visibility.text).to eq('Hidden')
end

When(/^toggle the display active locations flag$/) do
  @page.hide_active_locations
end

Then(/^I should not see see the active location$/) do
  expect(@page.locations.count).to eq(0)
end

Then(/^I should see the no locations available notice$/) do
  expect(@page).to have_notice
end

Given(/^an active location exists$/) do
  create(:user, :project_manager, :nicab)
  create(:location, :nicab)
end

Then(/^my locations should be hidden$/) do
  expect(Location.count).to eq(2)
  expect(Location.current.first).to be_hidden
end

Then(/^my location should be active$/) do
  expect(Location.count).to eq(2)
  expect(Location.current.first).not_to be_hidden
end

Then(/^I see that the location has a newer version$/) do
  expect(Location.where(version: 2)).to exist
end

When(/^I click on the location$/) do
  @page.click_on_first_location
end

Then(/^I am on the locations page$/) do
  location_page = AdminLocationPage.new
  expect(location_page).to be_displayed
end

When(/^I export the results to CSV$/) do
  @page.export_csv.click
end

Then(/^I am prompted to download the CSV$/) do
  expect(page.response_headers).to include(
    'Content-Disposition' => 'attachment; filename=locations.csv',
    'Content-Type'        => 'text/csv'
  )
end
