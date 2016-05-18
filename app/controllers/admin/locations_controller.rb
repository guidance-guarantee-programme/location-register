module Admin
  class LocationsController < Admin::BaseController
    before_action :set_autherised_location, only: [:update, :show, :edit]

    def index
      authorize Location
      @locations_directory = LocationsDirectory.new(current_user, params)
      respond_to do |format|
        format.html { @locations, @sorting_params = @locations_directory.paginated_locations }
        format.csv { render csv: LocationsCsv.new(@locations_directory.locations) }
      end
    end

    def show
    end

    def edit
      @booking_locations = policy_scope(Location.booking_locations)
    end

    def update
      updater = UpdateLocation.new(location: @location, user: current_user)
      @location = updater.update(permitted_attributes(@location))
      if @location.new_record?
        @booking_locations = policy_scope(Location.booking_locations)
        render :edit
      else
        redirect_to admin_location_path(@location.uid), notice: "Successfully updated #{@location.title}"
      end
    end

    private

    def set_autherised_location
      @location ||= Location.current.find_by!(uid: params[:id])
      authorize @location
    end
  end
end
