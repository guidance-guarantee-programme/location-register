class LocationsDirectory
  include ActiveModel::Model

  attr_reader :display_active, :display_hidden

  def initialize(current_user, params)
    @current_user = current_user
    @display_active = normalize_boolean_or_default(params.dig(:locations_directory, :display_active), true)
    @display_hidden = normalize_boolean_or_default(params.dig(:locations_directory, :display_hidden), false)
    @letter = params[:letter]
  end

  def hidden_flags
    [].tap do |flags|
      flags << true if display_hidden
      flags << false if display_active
    end
  end

  def locations
    Pundit.policy_scope!(
      @current_user,
      Location.with_visibility_flags(hidden_flags)
    )
  end

  def paginated_locations
    locations.alpha_paginate(
      @letter,
      ALPHABETICAL_PAGINATE_CONFIG.dup,
      &:title
    )
  end

  private

  def normalize_boolean_or_default(value, default)
    return default if value.nil?
    return false if %w[false 0].include?(value)

    value.present?
  end
end
