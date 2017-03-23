require 'rails_helper'

RSpec.describe NotifyPlannerJob, '#perform' do
  let(:payload) do
    JSON.generate(
      booking_location_id: 'booking_location_id',
      location_id: 'location_id'
    )
  end

  subject { described_class.new.perform('booking_location_id', 'location_id') }

  context 'when successful' do
    it 'issues a request to the planner API' do
      stub_request(
        :patch,
        'http://localhost:3002/api/v1/booking_requests/batch_reassign'
      ).with(body: payload).to_return(status: 204)

      subject
    end
  end

  context 'when unsuccessful' do
    it 'raises an error so the job retries' do
      stub_request(
        :patch,
        'http://localhost:3002/api/v1/booking_requests/batch_reassign'
      ).to_return(status: 500)

      expect { subject }.to raise_error(Faraday::ClientError)
    end
  end
end
