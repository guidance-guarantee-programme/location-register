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

  expect(@page.locatsions[0].title.text).to eq(@nicab_location.title)
end
