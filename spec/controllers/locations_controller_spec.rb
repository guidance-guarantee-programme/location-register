require 'rails_helper'

RSpec.describe LocationsController do
  describe '#index' do
    let!(:active_location) { FactoryGirl.create(:location, uid: '25de9301-50b5-49ba-a5da-7f40a2fcfe29') }
    let!(:hidden_location) { FactoryGirl.create(:location, uid: '25de9301-50b5-49ba-a5da-7f40a2fcfe29', hidden: true) }

    it 'renders the location as JSON' do
      get :index, format: 'json'
      expect(response).to be_ok
    end

    it 'requires JSON format to be passed in' do
      expect { get :index }.to raise_error(ActionController::UnknownFormat)
    end

    it 'does not include hidden locations by default' do
      get :index, format: 'json'
      expect(assigns(:locations)).to match_array([active_location])
    end

    context 'when include_hidden_locations flag is set' do
      it 'includes hidden location' do
        get :index, format: 'json', include_hidden_locations: 'true'
        expect(assigns(:locations)).to match_array([active_location, hidden_location])
      end
    end
  end
end
