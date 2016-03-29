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

  private

  def hidden_flags
    flags = []
    flags << true if params[:display_hidden].present?
    flags << false if params.fetch(:display_active, true).present?
    flags
  end
end
