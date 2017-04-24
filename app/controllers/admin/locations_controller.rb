module Admin
  class LocationsController < Admin::BaseController
    before_action :set_authorised_location, only: [:update, :show, :edit, :online_booking]

    def index
      authorize Location
      @locations_directory = LocationsDirectory.new(current_user, params)
      respond_to do |format|
        format.html { @locations, @sorting_params = @locations_directory.paginated_locations }
        format.csv { render csv: LocationsCsv.new(@locations_directory.locations) }
      end
    end

    def new
      @location = Location.new
      @booking_locations = policy_scope(Location.booking_locations)
    end

    def create
      @location = Location.new(location_params) do |new_location|
        new_location.organisation = current_user.organisation_slug
        new_location.editor = current_user
      end
      authorize @location

      if @location.save
        redirect_to edit_admin_location_path(@location.uid), notice: "Successfully updated #{@location.title}"
      else
        @booking_locations = policy_scope(Location.booking_locations)
        render :new
      end
    end

    def edit
      @booking_locations = policy_scope(Location.booking_locations)
    end

    def update
      if @location.update_attributes(location_params)
        redirect_to edit_admin_location_path(@location.uid), notice: "Successfully updated #{@location.title}"
      else
        @booking_locations = policy_scope(Location.booking_locations)
        render :edit
      end
    end

    def online_booking
    end

    private

    def location_params
      params.fetch(:location, {}).permit(Location::EDIT_FIELDS)
    end

    def set_authorised_location
      @location ||= Location.find_by!(uid: params[:id])
      authorize @location
    end
  end
end
