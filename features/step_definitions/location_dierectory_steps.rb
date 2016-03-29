Given(/^locations exist for my organisation$/) do
  FactoryGirl.create(:user, :project_manager, :nicab)
  FactoryGirl.create(:location, :nicab)
  FactoryGirl.create(:location, :nicab)
end

When(/^I visit the location directory$/) do
  @page = LocationDirectoryPage.new
  @page.load
end

Then(/^I can see locations for my organisation$/) do
  expect(@page.locations.size).to eq(2)

  @page.locations.each do |location|
    expect(location).to have_location_title
    expect(location).to have_address
    expect(location).to have_booking_hours
    expect(location).to have_telephone_number
    expect(location).to have_status
  end
end

Given(/^locations exist for other organisations$/) do
  FactoryGirl.create(:user, :project_manager, :nicab)
  FactoryGirl.create(:location, :cas)
  FactoryGirl.create(:location, :citi)
  @nicab_location = FactoryGirl.create(:location, :nicab)
end

Then(/^I can not see locations for other organisation$/) do
  expect(@page.locations.size).to eq(1)

  expect(@page.locations[0].location_title.text).to eq(@nicab_location.title)
end

Given(/^two locations exist called "([^"]*)" and "([^"]*)"$/) do |location1, location2|
  FactoryGirl.create(:user, :project_manager, :nicab)
  FactoryGirl.create(:location, :nicab, title: location1)
  FactoryGirl.create(:location, :nicab, title: location2)
end

When(/^I naviagte to the "([^"]*)" page$/) do |letter|
  @page.navigate_to(letter)
end

Then(/^I should see the "([^"]*)" location$/) do |title|
  expect(@page.locations.count).to eq(1)
  expect(@page.locations[0].location_title.text).to eq(title)
end

Given(/^a hidden location exists$/) do
  FactoryGirl.create(:user, :project_manager, :nicab)
  FactoryGirl.create(:location, :nicab, hidden: true)
end

Then(/^I should see not see the hidden location$/) do
  expect(@page.locations.count).to eq(0)
end

When(/^I toggle the display hidden locations flag$/) do
  @page.display_hidden_locations
end

Then(/^I should see see the hidden location$/) do
  expect(@page.locations.count).to eq(1)
  expect(@page.locations[0].checked_status.text).to eq('Hidden')
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

Given(/^a active location exists$/) do
  FactoryGirl.create(:user, :project_manager, :nicab)
  FactoryGirl.create(:location, :nicab)
end

When(/^I hide the active location$/) do
  @page.hide_first_location
end

Then(/^my locations should be hidden$/) do
  expect(Location.first).to be_hidden
end

When(/^I activate the hidden location$/) do
  @page.activate_first_location
end

Then(/^my location should be active$/) do
  expect(Location.first).not_to be_hidden
end
