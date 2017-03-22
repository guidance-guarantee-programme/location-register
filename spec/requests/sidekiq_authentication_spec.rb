require 'rails_helper'

RSpec.describe 'Sidekiq control panel' do
  scenario 'requires authentication' do
    with_real_sso do
      they_are_required_to_authenticate
    end
  end

  scenario 'successfully authenticating' do
    given_the_user(:user) do
      when_they_visit_the_sidekiq_panel
      then_they_are_authenticated
    end
  end

  def when_they_visit_the_sidekiq_panel
    get '/sidekiq'
  end

  def they_are_required_to_authenticate
    expect { get '/sidekiq' }.to raise_error(ActionController::RoutingError)
  end

  def then_they_are_authenticated
    expect(response).to be_ok
  end

  def given_the_user(type)
    GDS::SSO.test_user = create(type)
    yield
  ensure
    GDS::SSO.test_user = nil
  end

  def with_real_sso
    sso_env = ENV['GDS_SSO_MOCK_INVALID']
    ENV['GDS_SSO_MOCK_INVALID'] = '1'

    yield
  ensure
    ENV['GDS_SSO_MOCK_INVALID'] = sso_env
  end
end
