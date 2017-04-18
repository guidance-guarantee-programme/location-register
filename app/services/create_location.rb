class CreateLocation
  attr_reader :user

  def initialize(user:)
    @user = user
  end

  def create(params)
    address = params.delete('address')
    if address
      address_params = build_address(address)
      params.merge!(address_params)
    end

    create_new_version(params)

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

  def create_new_version(params)
    attributes = [
      params,
      version_attributes
    ].inject(:merge)

    @location = Location.new(clean(attributes))
    @location.save!
  end

  def version_attributes
    {
      state: 'current',
      version: 1,
      editor: user
    }
  end

  def clean(attributes)
    attributes.each do |key, value|
      attributes[key] = nil if value.is_a?(String) && value.blank?
    end
  end
end
