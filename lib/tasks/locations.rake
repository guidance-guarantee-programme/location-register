namespace :locations do
  desc 'Enable location(s) for weekend availability'
  task enable_weekends: :environment do
    enable      = ENV.fetch('ENABLE', true)
    location_id = ENV.fetch('LOCATION_ID')

    location = Location.active.current.find_by(uid: location_id)
    location.update(online_booking_weekends: enable)

    # Also flag any of its children, if present
    location.locations.current.active.update_all(online_booking_weekends: enable)
  end
end
