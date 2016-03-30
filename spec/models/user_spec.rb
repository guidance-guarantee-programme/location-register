require 'gds-sso/lint/user_spec'

RSpec.describe User do
  it_behaves_like 'a gds-sso user class'

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
