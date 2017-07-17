# frozen_string_literal: true
class LocationsCsv < CsvGenerator
  def initialize(record_or_records)
    @records = Array(record_or_records).map { |record| LocationWithAddress.new(record) }
  end

  def attributes
    %w(
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
    ).freeze
  end

  def hidden_formatter(value)
    value ? 'Hidden' : 'Active'
  end

  class LocationWithAddress
    attr_reader :attributes

    def initialize(location)
      @attributes = location.address.attributes.merge(location.attributes)
    end
  end
end
