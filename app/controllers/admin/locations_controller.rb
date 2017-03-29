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
      @location = Location.new(address: Address.new)
      @booking_locations = policy_scope(Location.booking_locations)
    end

    def create
      updater = CreateOrUpdateLocation.new(user: current_user)
      @location = updater.build(permitted_attributes(Location).to_h)
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
      updater = CreateOrUpdateLocation.new(location: @location, user: current_user)
      @location = updater.update(permitted_attributes(@location).to_h)
      if @location.new_record?
        @booking_locations = policy_scope(Location.booking_locations)
        render :edit
      else
        redirect_to edit_admin_location_path(@location.uid), notice: "Successfully updated #{@location.title}"
      end
    end

    def online_booking
    end

    private

    def set_authorised_location
      @location ||= Location.current.find_by!(uid: params[:id])
      authorize @location
    end
  end
end
