module Admin
  class LocationsController < Admin::BaseController
    def index
      authorize Location
      scope = Location.current.where(hidden: hidden_flags)

      @locations, @sorting_params = policy_scope(scope).alpha_paginate(
        params[:letter],
        ALPHABETICAL_PAGINATE_CONFIG.dup,
        &:title
      )
    end

    def update
      location = Location.find(params[:id])
      authorize location

      updater = UpdateLocation.new(uid: location.uid)
      updater.update!(permitted_attributes(location))
      flash[:notice] = "Successfully updated #{location.title}"
      redirect_to_locations_directory(location)
    rescue
      flash[:error] = "Error updating #{location.title}"
      redirect_to_locations_directory(location)
    end

    private

    def redirect_to_locations_directory(location)
      redirect_to admin_locations_path(
        letter: location.title[0],
        display_hidden: params[:display_hidden],
        display_active: params[:display_active]
      )
    end

    def hidden_flags
      [].tap do |flags|
        flags << true if params[:display_hidden].present?
        flags << false if params.fetch(:display_active, true).present?
      end
    end
  end
end
