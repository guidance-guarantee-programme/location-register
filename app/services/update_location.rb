class UpdateLocation
  attr_reader :location, :user

  def initialize(location:, user:)
    @location = location
    @user = user
  end

  def update!(params)
    params = params.with_indifferent_access
    if params['address']
      params['address_id'] = Address.find_or_create_from_params(params.delete('address')).id
    end

    return location if location.matches_params?(params)

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

    @location = Location.create!(clean(attributes))
  end

  def previous_version_attributes
    location.attributes.slice(*Location::EDIT_FIELDS)
  end

  def version_attributes
    {
      state: 'current',
      version: location.version + 1,
      editor: user
    }
  end

  def clean(attributes)
    attributes.each do |key, value|
      attributes[key] = nil if value.is_a?(String) && value.blank?
    end
  end
end
