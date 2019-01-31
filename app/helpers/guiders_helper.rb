module GuidersHelper
  def toggle_guider_button(guider)
    title = guider.inactive? ? 'Activate' : 'Deactivate'

    button_to(
      title,
      admin_location_guider_path(location_id: @location.uid, id: guider.id),
      method: :patch,
      class: 'btn btn-danger t-toggle'
    )
  end
end
