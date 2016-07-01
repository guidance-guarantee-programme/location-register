class AdminNewLocationPage < SitePrism::Page
  set_url '/admin/locations/new'

  element :organisation, '.t-organisation'
  element :location_title, '.t-location-title'
  element :booking_hours, '.t-booking-hours'
  element :visibility, '.t-visibility'
  element :booking_location, '.t-booking-location'

  element :address_line_1, '.t-address-line-1'
  element :address_line_2, '.t-address-line-2'
  element :address_line_3, '.t-address-line-3'
  element :town, '.t-town'
  element :county, '.t-county'
  element :postcode, '.t-postcode'
  element :phone, '.t-phone'
  element :twilio, '.t-twilio-number'

  element :hidden_true, '.t-hidden-true'

  element :save_button, '.t-save-button'
end
