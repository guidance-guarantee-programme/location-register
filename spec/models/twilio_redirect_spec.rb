require 'rails_helper'

RSpec.describe TwilioRedirection do
  describe '.for' do
    let(:twilio_number) { '+44123456789' }
    let!(:location) { create(:location, twilio_number: twilio_number, hidden: hidden) }

    context 'when the twilio number exists on a current location' do
      context 'and the location is active' do
        let(:hidden) { false }

        it 'redirects to the locations phone number' do
          expect(described_class.for(twilio_number).phone).to eq(location.phone)
        end

        context 'and it has a booking location' do
          let(:booking_location) { create(:location) }

          before do
            location.update_attribute(:booking_location, booking_location)
          end

          it 'still redirects to the locations phone number' do
            expect(described_class.for(twilio_number).phone).to eq(location.phone)
          end

          context 'and the location has no phone number' do
            before { location.update_attribute(:phone, nil) }

            it 'redirects to the booking locations phone number' do
              expect(described_class.for(twilio_number).phone).to eq(booking_location.phone)
            end
          end
        end
      end

      context 'and the location is hidden' do
        let(:hidden) { true }

        it 'redirects to the call centre' do
          expect(described_class.for(twilio_number).phone).to eq(::Location::TP_CALL_CENTRE_NUMBER)
        end
      end
    end

    context 'when the twilio number exists on a old location' do
      let(:user) { create(:user) }
      let(:params) { { 'twilio_number' => '+44987654321', 'phone' => '+44111222333' } }
      let!(:current_location) { CreateOrUpdateLocation.new(location: location, user: user).update(params) }

      context 'and the current version of the location is active' do
        let(:hidden) { false }

        it "redirects to the current location's phone number" do
          expect(described_class.for(twilio_number).phone).to eq(current_location.phone)
        end
      end

      context 'and the current version of the location is hidden' do
        let(:hidden) { true }

        it 'redirects to the call centre' do
          expect(described_class.for(twilio_number).phone).to eq(::Location::TP_CALL_CENTRE_NUMBER)
        end
      end
    end
  end
end
