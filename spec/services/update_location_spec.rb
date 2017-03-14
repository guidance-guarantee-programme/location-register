require 'rails_helper'

RSpec.describe CreateOrUpdateLocation do
  let(:user) { create(:user) }
  subject { described_class.new(location: location, user: user) }
  let(:address) { create(:address) }

  describe '#update' do
    let!(:location) {  Location.create!(params) }
    let(:other_user) { create(:user) }
    let(:params) do
      {
        organisation: 'cas',
        title: 'Test Vile',
        phone: '+44111111111',
        twilio_number: '+44111111112',
        hours: 'MON-FRI 9am-5pm',
        booking_location_uid: nil,
        address_id: address.id,
        state: 'current',
        version: 1,
        editor: other_user
      }.with_indifferent_access
    end

    context 'when an existing location would be unchanged by the update' do
      it 'does not create new location version' do
        expect { subject.update(params) }.not_to change { Location.count }
      end

      it 'ignores difference in versioning fields' do
        params[:created_at] = 10.days.ago
        params[:updated_at] = 10.days.ago
        expect { subject.update(params) }.not_to change { Location.count }
      end
    end

    context 'when an existing location would be changed by the update' do
      context 'and the location has guiders assigned to it' do
        let!(:guider) { location.guiders.create!(attributes_for(:guider)) }

        before do
          subject.update(params.merge(title: 'New title'))
        end

        it 'the guiders are still assigned to the new version of the location' do
          expect(location.current_version.guiders.pluck(:name, :email)).to eq([[guider.name, guider.email]])
        end

        it 'the guiders will no longer be assigned to the old version of the location' do
          expect(location.reload.guiders).to be_empty
        end
      end

      context 'when an error occurs during the creation of the new record' do
        before do
          allow(Location).to receive(:create!).and_raise(ActiveRecord::RecordInvalid)
        end

        it 'does not update the existing locations state' do
          subject.update(params) rescue nil
          expect(location.reload.state).to eq('current')
        end
      end

      context 'and the address field is not changed' do
        let(:update_params) { params.merge(title: 'New title') }

        it 'creates a new location entry in the database' do
          expect { subject.update(update_params) }.to change { Location.count }.by(1)
        end

        it 'change the state on the existing location to "old"' do
          subject.update(update_params)
          expect(location.reload.state).to eq('old')
        end

        it 'sets the editor to the passed in user' do
          expect(subject.update(update_params).editor).to eq(user)
        end

        it 'create a new location with the params' do
          expect { subject.update(update_params) }.to change { Location.count }.by(1)
        end

        it 'does not creates a new address entry in the database' do
          expect { subject.update(update_params) }.not_to change { Address.count }
        end

        it 'set the new locations state to current' do
          expect(subject.update(update_params).state).to eq('current')
        end

        it 'set the new locations version to one greater than the existing location' do
          expect(subject.update(update_params).version).to eq(location.version + 1)
        end

        context 'update only receives a subset of parameters' do
          let(:update_params) { { hidden: true }.with_indifferent_access }

          it 'create a new location with the params' do
            expect { subject.update(update_params) }.to change { Location.count }.by(1)
          end

          it 'uses copies un-modified attributes from the previous version' do
            expect(subject.update(update_params).title).to eq(location.title)
          end
        end
      end

      context 'and the address field is changed' do
        let(:update_params) do
          {
            address: {
              town: 'New town',
              postcode: 'AA1 2BB',
              address_line_1: 'Hope'
            }
          }.with_indifferent_access
        end
        let(:geocode) { instance_double('PostcodeGeocoder', valid?: true, coordinates: [-2.000, 52.000]) }

        before do
          allow(PostcodeGeocoder).to receive(:new).and_return(geocode)
        end

        it 'creates a new location entry in the database' do
          expect { subject.update(update_params) }.to change { Location.count }.by(1)
        end

        it 'creates a new address entry in the database' do
          expect { subject.update(update_params) }.to change { Address.count }.by(1)
        end

        it 'does copy un-modified address parameters' do
          expect(subject.update(update_params).address.postcode).not_to eq(location.address.postcode)
        end

        describe 'to an invalid address' do
          let(:geocode) { instance_double('PostcodeGeocoder', valid?: false) }

          it 'fails the update' do
            expect(subject.update(update_params)).not_to be_valid
          end

          it 'includes has access to the address error messages' do
            new_location = subject.update(update_params)
            expect(new_location.errors).to be_added(:address, :invalid)
            expect(new_location.address.errors).to be_added(:postcode, :geocoding_error)
          end

          it 'does not change the state on the old location' do
            subject.update(update_params)
            expect(location.reload.state).to eq('current')
          end
        end
      end
    end
  end
end
