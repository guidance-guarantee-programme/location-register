class AdminEditLocationPage < SitePrism::Page
  set_url '/admin/locations/{uid}/edit'

  element :location_title, '.t-location-title'
  element :booking_hours, '.t-booking-hours'
  element :make_location_visible, '.t-visibility'
  element :booking_location, '.t-booking-location'

  element :address_line_1, '.t-address-line-1'
  element :address_line_2, '.t-address-line-2'
  element :address_line_3, '.t-address-line-3'
  element :town, '.t-town'
  element :county, '.t-county'
  element :postcode, '.t-postcode'

  element :hidden_false, '.t-hidden-false'

  element :save_button, '.t-save-button'

  elements :errors, '.t-error-message'

  def error_messages
    errors.map(&:text)
  end
end
