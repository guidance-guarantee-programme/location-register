require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe LocationPolicy do
  subject { described_class }

  permissions :phone? do
    let(:user) { build(:user) }
    let(:admin) { build(:user, :cas, :pensionwise_admin) }
    let(:project_manager) { build(:user, :cita_e_w, :project_manager) }

    it 'grants access for a new location' do
      expect(subject).to permit(user, Location.new(version: nil))
      expect(subject).to permit(user, Location.new(version: 1))
    end

    context 'for an existing location' do
      it 'deny access for a normal user' do
        expect(subject).not_to permit(user, create(:location, version: 1))
      end

      it 'grant access for an admin user' do
        expect(subject).to permit(admin, create(:location, version: 1))
      end

      it 'grants access for an owning project manager' do
        expect(subject).to permit(project_manager, create(:location, :cita_e))
      end
    end
  end

  permissions :index? do
    it 'grant access to everyone' do
      expect(subject).to permit(nil, nil)
    end
  end

  permissions :update? do
    let(:cas_location) { build(:location, :cas) }
    let(:nicab_location) { build(:location, :nicab) }

    context 'when user is an admin' do
      let(:user) { build(:user, :cas, :pensionwise_admin) }

      it 'grants access to locations from all organisations' do
        expect(subject).to permit(user, cas_location)
        expect(subject).to permit(user, nicab_location)
      end
    end

    context 'when user is a project_manager' do
      let(:user) { build(:user, :cas, :project_manager) }

      it 'grants access if locations organisation matches users organisation_slug' do
        expect(subject).to permit(user, cas_location)
      end

      it 'deny access if location organisation does not match users organisation_slug' do
        expect(subject).not_to permit(user, nicab_location)
      end

      context 'when the user is CITA E&W' do
        let(:user) { build(:user, :cita_e_w, :project_manager) }

        it 'permits for the correct locations' do
          expect(subject).to permit(user, nicab_location)
          expect(subject).not_to permit(user, cas_location)
        end
      end
    end

    context 'when user does not have any specified permissions/roles' do
      let(:user) { build(:user, :cas) }

      it 'deny access to everyone' do
        expect(subject).not_to permit(user, cas_location)
        expect(subject).not_to permit(user, nicab_location)
      end
    end
  end

  describe '#permitted_attributes' do
    subject { described_class.new(user, record) }

    context 'when it is a new record' do
      let(:record) { Location }
      let(:user) { create(:user) }

      it do
        expect(subject.permitted_attributes).to eq(
          [
            :booking_location_uid,
            :hidden,
            :title,
            :hours,
            :accessibility_information,
            {
              address: %i[
                address_line_1
                address_line_2
                address_line_3
                town
                county
                postcode
              ]
            },
            :phone,
            :organisation
          ]
        )
      end
    end

    context 'when it is a project manager' do
      let(:record) { create(:location) }
      let(:user) { create(:user, :project_manager) }

      it do
        expect(subject.permitted_attributes).to eq(
          [
            :booking_location_uid,
            :hidden,
            :title,
            :hours,
            :accessibility_information,
            {
              address: %i[
                address_line_1
                address_line_2
                address_line_3
                town
                county
                postcode
              ]
            },
            :twilio_number,
            :online_booking_twilio_number,
            :online_booking_reply_to,
            :online_booking_enabled,
            :realtime
          ]
        )
      end
    end

    context 'when it is an existing record for a non admin user' do
      let(:record) { create(:location) }
      let(:user) { create(:user) }

      it do
        expect(subject.permitted_attributes).to eq(
          [
            :booking_location_uid,
            :hidden,
            :title,
            :hours,
            :accessibility_information,
            { address: %i[
              address_line_1
              address_line_2
              address_line_3
              town
              county
              postcode
            ] }
          ]
        )
      end
    end

    context 'when it is an existing record for a project manager' do
      let(:record) { create(:location) }
      let(:user) { create(:user, :project_manager) }

      it do
        expect(subject.permitted_attributes).to include(:online_booking_enabled, :realtime)
      end
    end
  end
end

RSpec.describe LocationPolicy::Scope do
  subject { described_class.new(user, Location) }
  let!(:cas_location) { create(:location, :cas) }
  let!(:nicab_location) { create(:location, :nicab) }

  context 'when user is an pensionwise_admin' do
    let(:user) { create(:user, :cas, :pensionwise_admin) }

    it 'users can see locations for all organisations' do
      expect(subject.resolve).to include(cas_location)
      expect(subject.resolve).to include(nicab_location)
    end
  end

  context 'when user is a project manager' do
    let(:user) { create(:user, :cas, :project_manager) }

    it 'users can see locations for their organisation' do
      expect(subject.resolve).to include(cas_location)
    end

    it 'users can not see locations for alternative organisations' do
      expect(subject.resolve).not_to include(nicab_location)
    end

    context 'when the user is a CITA E & W project manager' do
      let(:user) { create(:user, :cita_e_w, :project_manager) }

      it 'can see locations for CITA E & W and NI' do
        cita_england = create(:location, :cita_e)
        cita_wales   = create(:location, :cita_w)

        expect(subject.resolve).to include(cita_england, cita_wales, nicab_location)
      end
    end
  end

  context 'when user does not have any specified permissions/roles' do
    let(:user) { create(:user, :cas) }

    it 'user can not see any locations' do
      expect(subject.resolve).to be_empty
    end
  end
end
# rubocop:enable Metrics/BlockLength
