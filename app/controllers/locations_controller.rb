class LocationsController < ApplicationController
  def index
    authorize Location
    scope = Location.where(state: 'current', hidden: false).order(:title)

    @locations, @sorting_params = policy_scope(scope).alpha_paginate(
      params[:letter],
      ALPHABETICAL_PAGINATE_CONFIG.dup,
      &:title
    )
  end
end
