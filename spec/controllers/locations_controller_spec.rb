require 'rails_helper'

RSpec.describe LocationsController do
  describe '#index' do
    let(:externally_visible) { double }
    before do
      allow(Location).to receive(:externally_visible).and_return(externally_visible)
    end

    it 'renders the location as JSON' do
      get :index, format: 'json'
      expect(response).to be_ok
    end

    it 'requires JSON format to be passed in' do
      expect { get :index }.to raise_error(ActionController::UnknownFormat)
    end

    it 'assigns the result of externally visible' do
      get :index, format: 'json'
      expect(assigns(:locations)).to eq(externally_visible)
    end

    it 'passes the include_hidden_locations flag to Location.external_visible' do
      expect(Location).to receive(:externally_visible).with(include_hidden_locations: 'true')
      get :index, format: 'json', include_hidden_locations: 'true'
    end
  end
end
