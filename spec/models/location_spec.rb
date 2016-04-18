require 'rails_helper'

RSpec.describe Location do
  describe '.externally_visible' do
    let!(:active_location) { FactoryGirl.create(:location, uid: '25de9301-50b5-49ba-a5da-7f40a2fcfe29') }
    let!(:hidden_location) { FactoryGirl.create(:location, uid: '25de9301-50b5-49ba-a5da-7f40a2fcfe29', hidden: true) }

    it 'includes hidden locations when include_hidden_locations is true' do
      locations = Location.externally_visible(include_hidden_locations: true)
      expect(locations).to match_array([active_location, hidden_location])
    end

    it 'excludes hidden locations when include_hidden_locations is false' do
      locations = Location.externally_visible(include_hidden_locations: false)
      expect(locations).to match_array([active_location])
    end
  end
end
