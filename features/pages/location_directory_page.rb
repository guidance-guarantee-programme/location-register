class LocationDirectoryPage < SitePrism::Page
  set_url '/locations'

  sections :locations, '.location' do
    element :location_title, 'h2'
    element :address, '.address'
    element :booking_hours, '.booking_hours'
    element :telephone_number, '.telephone_number'
    element :status, '.status'
  end

  elements :pagination, '.pagination li a'

  def navigate_to(letter)
    pagination.detect { |p| p.text == letter }.click
  end
end
