class EditedField
  class AddressField < EditedField
    MAP_URL = '//maps.googleapis.com/maps/api/staticmap'.freeze

    def old_value
      @old_value ||= wrap(super)
    end

    def new_value
      @new_value ||= wrap(super)
    end

    private

    def wrap(value)
      return '' if value.nil?

      address = value.to_a.join('<br/>')
      address << image_url(value.point['coordinates']) if value.point && value.point['coordinates']
      address.html_safe # rubocop:disable Rails/OutputSafety
    end

    def image_url(coordinates)
      key = ENV['GOOGLE_MAP_API_KEY']
      lat_lng = coordinates.reverse.join(',')

      <<~HTML
        <br/>
        <img
          border="0"
          src="#{MAP_URL}?markers=#{lat_lng}&center=#{lat_lng}&zoom=15&size=250x150&key=#{key}">
        <br/>
        Longitude: #{coordinates.first}
        <br/>
        Latitude: #{coordinates.last}
      HTML
    end
  end
end
