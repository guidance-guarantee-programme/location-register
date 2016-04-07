class AdminLocationDirectoryPage < SitePrism::Page
  set_url '/admin/locations'

  sections :locations, '.t-location' do
    element :location_title, '.t-location-title'
    element :address, '.t-address'
    element :booking_hours, '.t-booking_hours'
    element :telephone_number, '.t-telephone_number'
    element :status, '.t-status'
    element :checked_status, '.t-location-status[checked] + .t-location-status-label'
    element :status_update, '.t-location-status-submit'
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

  def hide_first_location
    location_to_be_hidden = locations[0]
    location_to_be_hidden.status.choose('Hidden')
    location_to_be_hidden.status_update.click unless javascript_enabled?
  end

  def activate_first_location
    location_to_be_hidden = locations[0]
    location_to_be_hidden.status.choose('Active')
    location_to_be_hidden.status_update.click unless javascript_enabled?
  end

  def click_on_first_location
    location = locations[0]
    location.location_title.click
  end

  private

  def javascript_enabled?
    !has_filter_submit?
  end
end
