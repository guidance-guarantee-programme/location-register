module Admin
  class GuidersController < Admin::BaseController
    before_action :set_authorised_location
    before_action :set_guider, except: :create

    def index
    end

    def create
      @location.guiders.create!(guider_params)

      redirect_to admin_location_guiders_path(@location.uid)
    end

    def update
      @guider = @location.guiders.find(params[:id])
      @guider.toggle_hidden!

      redirect_back fallback_location: admin_location_guiders_path(@location.uid),
                    notice: 'The guider was hidden/unhidden'
    end

    private

    def guider_params
      params.require(:guider).permit(:name, :email)
    end

    def set_guider
      @guider = Guider.new
    end

    def set_authorised_location
      @location ||= Location.current.active.find_by!(uid: params[:location_id])
      authorize @location
    end
  end
end
