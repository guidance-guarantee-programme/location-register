require 'rails_helper'

RSpec.describe TwiliosController do
  describe '#handle_status' do
    before do
      allow(Bugsnag).to receive(:notify)
    end

    context 'when the call status was failed' do
      context 'but no CAB number is provided' do
        let(:params) { { 'DialCallStatus' => 'failed' } }

        it 'is successful' do
          get :handle_status, params: params
          expect(response).to be_ok
        end

        it 'raise an appropriate Bugsnag error' do
          get :handle_status, params: params
          expect(Bugsnag).to have_received(:notify).with(
            "Call forwarding failed for: 'No forwarding number'"
          )
        end
      end

      context 'and a know CAB number is provided' do
        let(:location) { create(:location, twilio_number: '+44123456789') }
        let(:params) { { 'DialCallStatus' => 'failed', 'Called' => location.twilio_number } }

        it 'is successful' do
          get :handle_status, params: params
          expect(response).to be_ok
        end

        it 'raise an appropriate Bugsnag error' do
          get :handle_status, params: params
          expect(Bugsnag).to have_received(:notify).with(
            "Call forwarding failed for: '#{location.title}' (#{location.twilio_number})"
          )
        end
      end

      context 'and an unknown number is provided' do
        let(:params) { { 'DialCallStatus' => 'failed', 'Called' => '+44123456789' } }

        it 'is successful' do
          get :handle_status, params: params
          expect(response).to be_ok
        end

        it 'raise an appropriate Bugsnag error' do
          get :handle_status, params: params
          expect(Bugsnag).to have_received(:notify).with(
            "Call forwarding failed for: 'Unknown Location' (+44123456789)"
          )
        end
      end
    end

    %w(busy completed no-answer).each do |call_status|
      context "when the call status is #{call_status}" do
        let(:location) { create(:location, twilio_number: '+44123456789') }
        let(:params) { { 'DialCallStatus' => call_status, 'Called' => location.twilio_number } }

        it 'is successful' do
          get :handle_status, params: params
          expect(response).to be_ok
        end

        it 'does not raise a Bugsnag error' do
          get :handle_status, params: params
          expect(Bugsnag).not_to have_received(:notify)
        end
      end
    end
  end
end
