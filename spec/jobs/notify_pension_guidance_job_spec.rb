require 'rails_helper'

RSpec.describe NotifyPensionGuidanceJob, '#perform' do
  subject { described_class.new.perform }

  context 'when successful' do
    it 'issues a request to the pension guidance API' do
      stub_request(
        :delete,
        'http://localhost:3000/locations_cache'
      ).to_return(status: 204)

      subject
    end
  end

  context 'when unsuccessful' do
    it 'raises an error to ensure the job retries' do
      stub_request(
        :delete,
        'http://localhost:3000/locations_cache'
      ).to_return(status: 500)

      expect { subject }.to raise_error(Faraday::ClientError)
    end
  end
end
