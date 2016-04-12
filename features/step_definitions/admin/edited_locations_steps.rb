Given(/^a location exists that has been hidden$/) do
  user = FactoryGirl.create(:user, :pensionwise_admin)
  location = FactoryGirl.create(:location, :nicab, created_at: 1.month.ago)
  updater = UpdateLocation.new(location: location, user: user)
  updater.update!(hidden: true)
end

When(/^I view the edited locations page$/) do
  @page = AdminEditedLocationsPage.new
  @page.load
end

Then(/^I should see a location with the following edits:$/) do |table|
  expect(@page).to have_locations count: 1
  location = @page.locations[0]

  expect(location).to have_edits count: table.hashes.count
  table.hashes.each_with_index do |edit, i|
    expect(location.edits[i].field.text).to eq(edit['Field'])
    expect(location.edits[i].old_value.text).to eq(edit['Old value'])
    expect(location.edits[i].new_value.text).to eq(edit['New value'])
  end
end

Given(/^a location exists that has been hidden and then made visible$/) do
  user = FactoryGirl.create(:user, :pensionwise_admin)
  location = FactoryGirl.create(:location, :nicab, created_at: 1.month.ago)
  updater = UpdateLocation.new(location: location, user: user)
  updater.update!(hidden: true)
  updater.update!(hidden: false)
end

Given(/^a location exists that was hidden yesterday$/) do
  user = FactoryGirl.create(:user, :pensionwise_admin)
  location = FactoryGirl.create(:location, :nicab, created_at: 1.month.ago)
  updater = UpdateLocation.new(location: location, user: user)
  travel_to(Time.zone.yesterday) do
    updater.update!(hidden: true)
  end
end

When(/^I navigate to the previous day$/) do
  @page.previous_day.click
end

Given(/^a location exists that with a address edit$/) do
  user = FactoryGirl.create(:user, :pensionwise_admin)
  location = FactoryGirl.create(:location, :nicab, :one_line_address, created_at: 1.month.ago)
  updater = UpdateLocation.new(location: location, user: user)
  updater.update!(address: { address_line_1: 'My New Address', postcode: 'UB9 4LH' })
end
