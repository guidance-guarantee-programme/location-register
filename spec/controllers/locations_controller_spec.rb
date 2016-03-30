require 'rails_helper'

RSpec.describe LocationsController do
  describe '#index' do
    before do
      FactoryGirl.create(:location, uid: '25de9301-50b5-49ba-a5da-7f40a2fcfe29')
    end

    it 'renders the location as JSON' do
      get :index, format: 'json'
      expect(response).to be_ok
    end

    it 'requires JSON format to be passed in' do
      expect { get :index }.to raise_error(ActionController::UnknownFormat)
    end
  end
end
