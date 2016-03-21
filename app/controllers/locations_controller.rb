class LocationsController < ApplicationController
  def index
    authorize Location
    scope = Location.where(state: 'current', hidden: false).order(:title)
    @locations = policy_scope(scope)
  end
end
