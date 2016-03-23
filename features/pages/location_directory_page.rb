class LocationDirectoryPage < SitePrism::Page
  set_url '/locations'

  sections :locations, '.t-location' do
    element :location_title, '.t-location-title'
    element :address, '.t-address'
    element :booking_hours, '.t-booking_hours'
    element :telephone_number, '.t-telephone_number'
    element :status, '.t-status'
  end

  elements :pagination, '.pagination li a'

  def navigate_to(letter)
    pagination.detect { |p| p.text == letter }.click
  end
end
