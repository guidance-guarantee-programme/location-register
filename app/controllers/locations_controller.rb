class LocationsController < ApplicationController
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
    if location.update_attributes(permitted_attributes(location))
      flash[:notice] = "Successfully updated #{location.title}"
    else
      flash[:error] = "Error updating #{location.title}"
    end
    redirect_to_locations_directory(location)
  end

  private

  def redirect_to_locations_directory(location)
    redirect_to locations_path(
      letter: location.title[0],
      display_hidden: params[:display_hidden],
      display_active: params[:display_active]
    )
  end

  def hidden_flags
    flags = []
    flags << true if params[:display_hidden].present?
    flags << false if params.fetch(:display_active, true).present?
    flags
  end
end
