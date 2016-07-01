Given(/^I am a pensionwise admin$/) do
  create(:user, :pensionwise_admin)
end

When(/^I create a new booking location with a twilio number$/) do
  @page = AdminNewLocationPage.new
  @page.load

  @page.location_title.set 'Fun Land'
  @page.booking_hours.set 'Mon-Fri 9am-5pm'
  @page.address_line_1.set 'Fun Lane'
  @page.town.set 'Fun'
  @page.county.set 'Fun'
  @page.phone.set '+442712345678'
  @page.twilio.set '+442712345678'
  @page.postcode.set 'RH1 6EW'
  @page.organisation.select 'cita'
  @page.visibility.set true

  @page.save_button.click
end

When(/^I create a new booking location$/) do
  create(:user, :project_manager, :nicab)

  @page = AdminNewLocationPage.new
  @page.load

  @page.location_title.set 'Fun Land'
  @page.booking_hours.set 'Mon-Fri 9am-5pm'
  @page.address_line_1.set 'Fun Lane'
  @page.town.set 'Fun'
  @page.county.set 'Fun'
  @page.phone.set '+442712345678'
  @page.postcode.set 'RH1 6EW'
  @page.hidden_true.set true

  @page.save_button.click
end

Then(/^the location is created$/) do
  expect(Location.current.last.title).to eq('Fun Land')
end

Then(/^the location is hidden$/) do
  expect(Location.current.last).to be_hidden
end

Given(/^a hidden location exists with a twilio number$/) do
  create(:user, :project_manager, :cas)
  @location = create(:location, twilio_number: '+442712345678', hidden: true)
end

When(/^I toggle the locations visiblity$/) do
  @page = AdminEditLocationPage.new
  @page.load(uid: @location.uid)

  @page.hidden_false.set false

  @page.save_button.click
end

Then(/^the location is visible$/) do
  expect(Location.current.last).not_to be_hidden
end

Given(/^a hidden location exists without a twilio number$/) do
  create(:user, :project_manager, :cas)
  @location = create(:location, twilio_number: nil, hidden: true)
end

Then(/^I get a permission denied error$/) do
  expect(@page).to have_errors
end
