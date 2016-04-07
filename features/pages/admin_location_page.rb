class AdminLocationPage < SitePrism::Page
  set_url '/admin/locations/{uid}'

  element :location_title, '.t-location-title'
  element :address, '.t-address'
  element :booking_hours, '.t-booking_hours'
  element :telephone_number, '.t-telephone_number'
  element :status, '.t-status'
  element :checked_status, '.t-location-status[checked] + .t-location-status-label'
  element :status_update, '.t-location-status-submit'

  element :edit_button, '.t-edit-button'
end
