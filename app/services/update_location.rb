class UpdateLocation
  VERSIONING_ATTRIBUTES = %w(id created_at state version updated_at).freeze

  attr_reader :location, :user

  def initialize(location:, user:)
    @location = location
    @user = user
  end

  def update!(params)
    return location if no_changes?(params)

    Location.transaction do
      location.update_attributes!(state: 'old')
      create_new_version!(params)
    end
  end

  private

  def create_new_version!(params)
    attributes = [
      previous_version_attributes,
      params,
      version_attributes
    ].inject(:merge)

    Location.create!(attributes)
  end

  def previous_version_attributes
    location.attributes.except(*VERSIONING_ATTRIBUTES)
  end

  def version_attributes
    {
      state: 'current',
      version: location.version + 1,
      editor: user
    }
  end

  def no_changes?(params)
    params.all? do |key, value|
      VERSIONING_ATTRIBUTES.include?(key.to_s) ||
        location[key] == value ||
        (location[key].blank? && value.blank?)
    end
  end
end
