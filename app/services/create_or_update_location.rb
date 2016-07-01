class CreateOrUpdateLocation
  attr_reader :location, :user

  def initialize(location: nil, user:)
    @location = location
    @user = user
  end

  def build(params)
    address = params.delete('address')
    if address
      address_params = build_address(address)
      params.merge!(address_params)
    end
    params['organisation'] ||= user.organisation_slug

    build_new_version(params)
  end

  def update(params)
    address = params.delete('address')
    if address
      address_params = build_address(address)
      params.merge!(address_params)
    end

    return location if location.matches_params?(params)

    Location.transaction do
      begin
        location.update_attributes!(state: 'old')
        create_new_version(params)
      rescue ActiveRecord::RecordInvalid
        raise ActiveRecord::Rollback
      end
    end
    @location
  end

  private

  def build_address(address_params)
    address = Address.find_or_initialize_from_params(address_params)
    params = {}
    params['address_id'] = address.id
    params['address'] = address if address.new_record?
    params
  end

  def build_new_version(params)
    attributes = [
      previous_version_attributes,
      params,
      version_attributes
    ].inject(:merge)

    @location = Location.new(clean(attributes))
  end

  def create_new_version(params)
    build_new_version(params)
    @location.save!
  end

  def previous_version_attributes
    location ? location.attributes.slice(*Location::EDIT_FIELDS) : {}
  end

  def version_attributes
    {
      state: 'current',
      version: next_version_number,
      editor: user
    }
  end

  def clean(attributes)
    attributes.each do |key, value|
      attributes[key] = nil if value.is_a?(String) && value.blank?
    end
  end

  def next_version_number
    location ? location.version + 1 : 1
  end
end
