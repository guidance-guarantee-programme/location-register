require 'rails_helper'

RSpec.feature 'Booking Locations API' do
  scenario 'Requesting a booking location by ID' do
    given_a_permitted_gds_sso_user
    and_a_booking_location_exists
    when_one_of_its_children_are_requested
    then_the_response_is_ok
    and_the_booking_location_is_returned_as_json
  end

  scenario 'Requesting a booking location by incorrect ID' do
    given_a_permitted_gds_sso_user
    when_a_request_is_made_with_an_invalid_uid
    then_the_response_is_a_404
  end

  def given_a_permitted_gds_sso_user
    @user = create(:user)
  end

  def when_a_request_is_made_with_an_invalid_uid
    visit api_v1_booking_location_path(uid: 'whoops')
  end

  def then_the_response_is_a_404
    expect(page.status_code).to eq(404)
  end

  def and_a_booking_location_exists
    @booking_location = create(:booking_location, editor: @user)
  end

  def when_one_of_its_children_are_requested
    @child_location = @booking_location.locations.first
    visit api_v1_booking_location_path(uid: @child_location.uid, format: :json)
  end

  def then_the_response_is_ok
    expect(page.status_code).to eq(200)
  end

  def and_the_booking_location_is_returned_as_json
    expect(JSON.parse(page.body)).to include('uid' => @booking_location.uid)
  end
end
