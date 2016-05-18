require 'rails_helper'

RSpec.describe LocationPolicy do
  subject { described_class }

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
    end

    context 'when user does not have any specified permissions/roles' do
      let(:user) { build(:user, :cas) }

      it 'deny access to everyone' do
        expect(subject).not_to permit(user, cas_location)
        expect(subject).not_to permit(user, nicab_location)
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
  end

  context 'when user does not have any specified permissions/roles' do
    let(:user) { create(:user, :cas) }

    it 'user can not see any locations' do
      expect(subject.resolve).to be_empty
    end
  end
end
