module Admin
  class LocationsController < Admin::BaseController
    before_action :set_autherised_location, only: [:update, :show, :edit]

    def index
      authorize Location
      scope = Location.current.where(hidden: hidden_flags)

      @locations, @sorting_params = policy_scope(scope).alpha_paginate(
        params[:letter],
        ALPHABETICAL_PAGINATE_CONFIG.dup,
        &:title
      )
    end

    def show
    end

    def edit
      @booking_locations = policy_scope(Location.current.where(booking_location_uid: nil))
    end

    def update
      updater = UpdateLocation.new(location: @location, user: current_user)
      updater.update!(permitted_attributes(@location))
      flash[:notice] = "Successfully updated #{@location.title}"
      redirect_to admin_locations_path(location_params)
    rescue
      flash[:error] = "Error updating #{@location.title}"
      redirect_to admin_locations_path(location_params)
    end

    private

    def set_autherised_location
      @location ||= Location.current.find_by!(uid: params[:id])
      authorize @location
    end

    def location_params
      {
        letter: @location.title[0],
        display_hidden: display_hidden?,
        display_active: display_active?
      }
    end

    def hidden_flags
      [].tap do |flags|
        flags << true if display_hidden?
        flags << false if display_active?
      end
    end

    def display_active?
      params.fetch(:display_active, true).present?
    end

    def display_hidden?
      params[:display_hidden].present?
    end
  end
end
