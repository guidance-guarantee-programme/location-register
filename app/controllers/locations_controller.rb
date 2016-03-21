class LocationsController < ApplicationController
  def index
    @locations = Location.where(state: 'current', hidden: false).order(:title)
  end
end
