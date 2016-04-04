class LocatorsController < ApplicationController
  def index
    expires_in Rails.application.config.cache_max_age, public: true
  end
end
