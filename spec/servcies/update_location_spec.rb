require 'rails_helper'

RSpec.describe UpdateLocation do
  let(:uid) { SecureRandom.uuid }
  subject { described_class.new(uid: uid) }
  let(:address) { FactoryGirl.create(:address) }

  describe '#update' do
    let(:params) do
      {
        organisation: 'CAS',
        title: 'Test Vile',
        phone: '01111111111',
        hours: 'MON-FRI 9am-5pm',
        booking_location_uid: nil,
        address_id: address.id
      }
    end

    context 'when an existing location does not exist' do
      it 'raise ActiveRecord Not Found error' do
        expect { subject.update!(params) }.to raise_error(StandardError)
      end
    end

    context 'when an existing location would be unchanged by the update' do
      before do
        Location.create(
          params.merge(
            uid: uid,
            state: 'current',
            version: 1
          )
        )
      end

      it 'does not create new location version' do
        expect { subject.update!(params) }.not_to change { Location.count }
      end

      it 'ignores difference in versioning fields' do
        params[:created_at] = 10.days.ago
        params[:updated_at] = 10.days.ago
        expect { subject.update!(params) }.not_to change { Location.count }
      end

      it 'maps empty string to nil' do
        params[:booking_location] = ''
        expect { subject.update!(params) }.not_to change { Location.count }
      end
    end

    context 'when an existing location would be changed by the update' do
      let!(:location) do
        Location.create(
          params.merge(
            title: 'Old Town',
            uid: uid,
            state: 'current',
            version: 1
          )
        )
      end

      it 'creates a new location entry in the database' do
        expect(subject.update!(params)).not_to eq(location)
      end

      it 'change the state on the existing location to "old"' do
        subject.update!(params)
        expect(location.reload.state).to eq('old')
      end

      it 'create a new location with the params' do
        expect { subject.update!(params) }.to change { Location.count }.by(1)
      end

      it 'set the new locations state to current' do
        expect(subject.update!(params).state).to eq('current')
      end

      it 'set the new locations version to one greater than the existing location' do
        expect(subject.update!(params).version).to eq(location.version + 1)
      end
    end

    context 'missing params passed to update method' do
      let!(:location) do
        Location.create(
          params.merge(
            uid: uid,
            state: 'current',
            version: 1
          )
        )
      end
      let(:update_params) { { hidden: true } }

      it 'create a new location with the params' do
        expect { subject.update!(update_params) }.to change { Location.count }.by(1)
      end
      it 'uses values from old record' do
        location = subject.update!(update_params)
        expect(location.title).to eq(params[:title])
      end
    end
  end
end
