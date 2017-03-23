class NotifyPlannerJob < ApplicationJob
  queue_as :default

  def perform(booking_location_id, location_id)
    PlannerApi.new.call(booking_location_id, location_id)
  end
end
