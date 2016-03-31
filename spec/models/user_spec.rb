require 'gds-sso/lint/user_spec'

RSpec.describe User do
  it_behaves_like 'a gds-sso user class'

  describe '#pensionwise_admin?' do
    it 'true when permissions contains "pensionwise_admin" permission' do
      expect(User.new(permissions: ['pensionwise_admin'])).to be_pensionwise_admin
    end

    it 'false when permissions does not contains "admin" permission' do
      expect(User.new(permissions: [])).not_to be_pensionwise_admin
      expect(User.new(permissions: ['other'])).not_to be_pensionwise_admin
    end
  end

  describe '#project_manager?' do
    it 'true when permissions contains "project_manager" permission' do
      expect(User.new(permissions: ['project_manager'])).to be_project_manager
    end

    it 'false when permissions does not contains "project_manager" permission' do
      expect(User.new(permissions: [])).not_to be_project_manager
      expect(User.new(permissions: ['other'])).not_to be_project_manager
    end
  end
end
