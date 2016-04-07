class AdminEditedLocationsPage < SitePrism::Page
  set_url '/admin/edited_locations'

  element :previous_day, '.t-previous-day'

  sections :locations, '.t-location' do
    element :location_title, '.t-location-title'

    sections :edits, '.t-edit' do
      element :field, '.t-edited-field'
      element :old_value, '.t-edited-old'
      element :new_value, '.t-edited-new'
      element :created_at, '.t-edited-created-at'
      element :edited_by, '.t-edited-by'
    end
  end
end
