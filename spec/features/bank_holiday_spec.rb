require 'rails_helper'

RSpec.feature 'Locations API during a bank holiday' do
  scenario 'Requesting the locations api on a bank holiday' do
    given_a_location_with_online_booking
    when_we_are_on_a_bank_holiday do
      and_i_call_the_locations_api
      then_it_shows_the_location_as_disabled
    end
  end

  scenario 'Requesting the locations on a non bank holiday' do
    given_a_location_with_online_booking
    when_we_are_not_on_a_bank_holiday do
      and_i_call_the_locations_api
      then_it_shows_the_location_as_enabled
    end
  end

  def given_a_location_with_online_booking
    create(:location, :allows_online_booking)
  end

  def when_we_are_on_a_bank_holiday(&block)
    travel_to(Date.parse('14/04/2017'), &block)
  end

  def when_we_are_not_on_a_bank_holiday(&block)
    travel_to(Date.parse('13/04/2017'), &block)
  end

  def and_i_call_the_locations_api
    visit locations_path(format: :json)
  end

  def then_it_shows_the_location_as_enabled
    json = JSON.parse(page.body)
    status = json['features'][0]['properties']['online_booking_enabled']
    expect(status).to be_truthy
  end

  def then_it_shows_the_location_as_disabled
    json = JSON.parse(page.body)
    status = json['features'][0]['properties']['online_booking_enabled']
    expect(status).to be_falsey
  end
end
