require 'rails_helper'

RSpec.describe TwiliosController do
  describe '#handle_status' do
    before do
      allow(Bugsnag).to receive(:notify)
    end

    context 'call status is failed (redirected to an invalid number) without a Called number' do
      let(:params) { { 'DialCallStatus' => 'failed' } }

      it 'is successful' do
        get :handle_status, params
        expect(response).to be_ok
      end

      it 'does not raise a Bugsnag error' do
        get :handle_status
        expect(Bugsnag).not_to have_received(:notify)
      end
    end

    context 'call status failed (redirected to an invalid number) with a Called number' do
      let(:location) { create(:location, twilio_number: '+44123456789') }
      let(:params) { { 'DialCallStatus' => 'failed', 'Called' => location.twilio_number } }

      it 'is successful' do
        get :handle_status, params
        expect(response).to be_ok
      end

      it 'raise a Bugsnag error' do
        get :handle_status, params
        expect(Bugsnag).to have_received(:notify).with(
          "Invalid number detected for: '#{location.title}' (#{location.phone})"
        )
      end
    end

    context 'call status is busy called with a Called number' do
      let(:location) { create(:location, twilio_number: '+44123456789') }
      let(:params) { { 'DialCallStatus' => 'busy', 'Called' => location.twilio_number } }

      it 'is successful' do
        get :handle_status, params
        expect(response).to be_ok
      end

      it 'does not raise a Bugsnag error' do
        get :handle_status, params
        expect(Bugsnag).not_to have_received(:notify)
      end
    end
  end
end
