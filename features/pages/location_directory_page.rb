class LocationDirectoryPage < SitePrism::Page
  set_url '/locations'

  sections :locations, '.t-location' do
    element :location_title, '.t-location-title'
    element :address, '.t-address'
    element :booking_hours, '.t-booking_hours'
    element :telephone_number, '.t-telephone_number'
    element :status, '.t-status'
  end

  elements :pagination, '.t-pagination__letter'
  element :filter_submit, '.t-filter-submit'

  element :notice, '.t-notice'

  def navigate_to(letter)
    if javascript_enabled?
      # choose does not work in poltergeist as checkbox is hidden
      find('label', text: letter).click
    else
      choose(letter)
    end
    filter_submit.click unless javascript_enabled?
  end

  def display_hidden_locations
    check('Hidden Locations')
    filter_submit.click unless javascript_enabled?
  end

  def hide_active_locations
    uncheck('Active Locations')
    filter_submit.click unless javascript_enabled?
  end

  def javascript_enabled?
    !has_filter_submit?
  end
end
