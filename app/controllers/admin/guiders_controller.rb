module Admin
  class GuidersController < Admin::BaseController
    before_action :set_authorised_location, :set_guider

    def index
      @guiders = @location.guiders
    end

    def create
      @location.guiders.create!(guider_params)

      redirect_to admin_location_guiders_path(@location.uid)
    end

    private

    def guider_params
      params.require(:guider).permit(:name, :email)
    end

    def set_guider
      @guider = Guider.new(location: @location)
    end

    def set_authorised_location
      @location ||= Location.current.find_by!(uid: params[:location_id])
      authorize @location
    end
  end
end
