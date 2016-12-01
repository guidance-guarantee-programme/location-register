class AdminEditedLocationsPage < SitePrism::Page
  set_url '/admin/edited_locations'

  element :previous_day, '.t-previous-day'

  sections :edits, '.t-edit' do
    element :field, '.t-edited-field'
    element :old_value, '.t-edited-old'
    element :new_value, '.t-edited-new'
  end

  def click_on_first_location
    location = locations[0]
    location.location_title.click
  end
end
