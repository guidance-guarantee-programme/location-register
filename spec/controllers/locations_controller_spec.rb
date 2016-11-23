require 'rails_helper'

RSpec.describe LocationsController do
  describe '#index' do
    before { allow(Location).to receive(:externally_visible).and_return(double) }

    it 'renders the location as JSON' do
      get :index, format: 'json', params: {}
      expect(response).to be_ok
    end

    it 'requires JSON format to be passed in' do
      expect { get :index }.to raise_error(ActionController::UnknownFormat)
    end

    it 'passes the include_hidden_locations flag to Location.external_visible' do
      expect(Location).to receive(:externally_visible).with(include_hidden_locations: 'true')
      get :index, format: 'json', params: { include_hidden_locations: 'true' }
    end
  end
end
