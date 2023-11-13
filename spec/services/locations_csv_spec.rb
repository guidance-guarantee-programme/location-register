# frozen_string_literal: true
require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe LocationsCsv do
  let(:separator) { ',' }

  describe '#csv' do
    subject { described_class.new(Location.new(address: Address.new)).call.lines }

    it 'generates headings' do
      expect(subject.first.chomp.split(separator)).to match_array(
        %w[
          uid
          title
          address_line_1
          address_line_2
          address_line_3
          town
          county
          postcode
          phone
          hours
          hidden
          booking_location_uid
          organisation
          online_booking_enabled
          realtime
        ]
      )
    end

    context 'data rows are correct generated' do
      let(:location) { create(:location) }

      subject { described_class.new(location).call.lines }

      it 'generates correctly mapped rows' do
        expect(subject.last.chomp.split(separator).reject(&:empty?)).to match_array(
          [
            location.uid,
            location.title,
            location.phone,
            location.hours,
            location.address.address_line_1,
            location.address.address_line_2,
            location.address.address_line_3,
            location.address.town,
            location.address.county,
            location.address.postcode,
            'Active',
            'cas',
            'false',
            'false'
          ]
        )
      end
    end

    context '#hidden_formatter' do
      subject { described_class.new(Location.new(address: Address.new)) }

      it 'when value is true displays `Hidden`' do
        expect(subject.hidden_formatter(true)).to eq('Hidden')
      end

      it 'when value is false displays `Active`' do
        expect(subject.hidden_formatter(false)).to eq('Active')
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
