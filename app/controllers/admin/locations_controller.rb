module Admin
  class LocationsController < Admin::BaseController
    before_action :set_autherised_location, only: [:update, :show, :edit]

    def index
      authorize Location
      scope = Location.with_visibility_flags(hidden_flags)

      respond_to do |format|
        format.html do
          @locations, @sorting_params = policy_scope(scope).alpha_paginate(
            params[:letter],
            ALPHABETICAL_PAGINATE_CONFIG.dup,
            &:title
          )
        end
        format.csv do
          render csv: LocationsCsv.new(policy_scope(scope))
        end
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
