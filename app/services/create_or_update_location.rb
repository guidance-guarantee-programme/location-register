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
    old_location = location
    build_new_version(params)
    @location.save!

    old_location.guider_assignments.update_all(location_id: @location.id)

    reassign_booking_location(old_location.canonical_location, @location.booking_location)
  end

  def reassign_booking_location(old_booking_location, new_booking_location)
    return unless old_booking_location && new_booking_location
    return unless old_booking_location.uid != new_booking_location.uid

    new_booking_location.guider_ids |= old_booking_location.guider_ids
    new_booking_location.save!

    NotifyPensionGuidanceJob.perform_later
    NotifyPlannerJob.perform_later(new_booking_location.uid, location.uid)
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
    attributes.except(:online_booking_reply_to).each do |key, value|
      attributes[key] = nil if value.is_a?(String) && value.blank?
    end
  end

  def next_version_number
    location ? location.version + 1 : 1
  end
end
