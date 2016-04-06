module Admin
  class EditedLocationsController < Admin::BaseController
    def index
      @date = Date.parse(params[:date] || Time.zone.today.to_s)
      authorize Location
      scope = Location.where(created_at: @date...@date + 1)

      @edited_locations = EditedLocation.all(policy_scope(scope))
    end
  end
end
