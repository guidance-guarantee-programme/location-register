class Address < ActiveRecord::Base
  def self.find_or_create_from_params(params)
    find_or_create_by!(
      address_line_1: params['address_line_1'].presence,
      address_line_2: params['address_line_2'].presence,
      address_line_3: params['address_line_3'].presence,
      town: params['town'].presence,
      county: params['county'].presence,
      postcode: params['postcode'].presence
    )
  end

  def initialize(*args)
    super
    self.uid ||= SecureRandom.uuid
  end

  def to_a
    [
      address_line_1,
      address_line_2,
      address_line_3,
      town,
      county,
      postcode
    ].map(&:presence).compact
  end
end
