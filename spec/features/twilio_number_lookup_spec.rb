require 'rails_helper'

RSpec.describe 'Twilio number lookup', type: :request do
  context 'when location exists for the uid' do
    it 'will forward to the location phones' do
      given_a_location_exists
      when_twilio_requests_a_forwarding_number
      then_xml_containing_the_location_number_is_returned
    end

    context 'and the location has booking location' do
      it 'will forward to the location phones if a number exists' do
        given_a_location_exists_with_a_booking_location_and_own_phone
        when_twilio_requests_a_forwarding_number
        then_xml_containing_the_location_number_is_returned
      end

      it 'will forward to the booking location phones if no number of its own exists' do
        given_a_location_exists_with_a_booking_location
        when_twilio_requests_a_forwarding_number
        then_xml_containing_the_booking_location_number_is_returned
      end
    end

    it 'will include the locations extension is one exists' do
      given_a_location_exists_that_requires_an_extension
      when_twilio_requests_a_forwarding_number
      then_xml_containing_the_location_number_and_extension_is_returned
    end

    it 'will forward to the booking location phone number' do
      given_a_location_exists_with_a_booking_location
      when_twilio_requests_a_forwarding_number
      then_xml_containing_the_booking_location_number_is_returned
    end

    context 'when location is hidden' do
      it 'will forward to the booking location phone number if it is active' do
        given_a_hidden_location_exists_with_a_booking_location
        when_twilio_requests_a_forwarding_number
        then_xml_containing_the_booking_location_number_is_returned
      end

      it 'will forward to the TP call centre' do
        given_a_hidden_location_exists
        when_twilio_requests_a_forwarding_number
        then_xml_containing_the_tp_call_centre_is_returned
      end
    end
  end

  context 'when call centre exists for the uid' do
    it 'will forward to the location phones' do
      given_a_call_centre_exists
      when_twilio_requests_a_forwarding_number
      then_xml_containing_the_call_centre_number_is_returned
    end
  end

  context 'when no call centre number is passed in' do
    it 'will forward to the location phones' do
      when_twilio_requests_a_blank_forwarding_number
      then_a_bad_request_status_is_returned
    end
  end

  context 'when no call centre number is passed in' do
    it 'will forward to the location phones' do
      when_twilio_requests_a_unknown_forwarding_number
      then_a_not_found_status_is_returned
    end
  end

  def given_a_location_exists
    @redirection = create(:location)
  end

  def given_a_location_exists_that_requires_an_extension
    @redirection = create(:location, extension: '25')
  end

  def given_a_location_exists_with_a_booking_location
    @booking_location = create(:location)
    @redirection = create(:location, phone: nil, booking_location: @booking_location)
  end

  def given_a_location_exists_with_a_booking_location_and_own_phone
    @booking_location = create(:location)
    @redirection = create(:location)

    # Associate after creation, as factory clears the phone (and hours)
    # on creation if a booking location is present.
    @redirection.update_attribute(:booking_location, @booking_location)
  end

  def given_a_hidden_location_exists_with_a_booking_location
    @booking_location = create(:location)
    @redirection = create(:location, phone: nil, booking_location: @booking_location, hidden: true)
  end

  def given_a_hidden_location_exists
    @redirection = create(:location, hidden: true)
  end

  def given_a_call_centre_exists
    @redirection = create(:call_centre)
  end

  def when_twilio_requests_a_forwarding_number
    post twilio_path(format: :xml), params: { To: @redirection.twilio_number }
  end

  def when_twilio_requests_a_blank_forwarding_number
    post twilio_path(format: :xml), params: { To: '' }
  end

  def when_twilio_requests_a_unknown_forwarding_number
    post twilio_path(format: :xml), params: { To: '+1111111' }
  end

  def then_xml_containing_the_location_number_is_returned
    expect(response.body).to eq(xml_for("<Number>#{@redirection.phone}</Number>"))
  end

  def then_xml_containing_the_location_number_and_extension_is_returned
    xml_response = xml_for("<Number sendDigits=\"#{@redirection.extension}\">#{@redirection.phone}</Number>")
    expect(response.body).to eq(xml_response)
  end

  def then_xml_containing_the_booking_location_number_is_returned
    expect(response.body).to eq(xml_for("<Number>#{@booking_location.phone}</Number>"))
  end

  def then_xml_containing_the_tp_call_centre_is_returned
    expect(response.body).to eq(xml_for("<Number>#{Location::TP_CALL_CENTRE_NUMBER}</Number>"))
  end

  def then_xml_containing_the_call_centre_number_is_returned
    expect(response.body).to eq(xml_for("<Number>#{@redirection.phone}</Number>"))
  end

  def then_a_bad_request_status_is_returned
    expect(response.code).to eq('400')
  end

  def then_a_not_found_status_is_returned
    expect(response.code).to eq('404')
  end

  def xml_for(number)
    <<~XML_END
      <?xml version="1.0" encoding="UTF-8"?>
      <Response>
        <Dial action="http://www.example.com/twilio/handle_status" method="GET">
          #{number}
        </Dial>
      </Response>
    XML_END
  end
end
