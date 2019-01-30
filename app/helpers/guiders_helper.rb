module GuidersHelper
  def toggle_guider_button(guider)
    title = guider.hidden? ? 'Unhide' : 'Hide'

    button_to(
      title,
      admin_location_guider_path(location_id: @location.uid, id: guider.id),
      method: :patch,
      class: 'btn btn-danger t-toggle'
    )
  end
end
