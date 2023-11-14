class Address < ApplicationRecord
  def self.find_or_initialize_from_params(params)
    find_or_initialize_by(
      address_line_1: params['address_line_1'].presence,
      address_line_2: params['address_line_2'].presence,
      address_line_3: params['address_line_3'].presence,
      town: params['town'].presence,
      county: params['county'].presence,
      postcode: params['postcode'].presence
    )
  end

  validates :postcode, :address_line_1, presence: true
  validate :valid_uk_postcode
  before_validation :set_point_from_postcode

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

  private

  def valid_uk_postcode
    return if postcode.blank?

    uk_postcode = UKPostcode.parse(postcode)
    if uk_postcode.full_valid?
      errors.add(:postcode, :geocoding_error) if point.blank?
    else
      errors.add(:postcode, :non_uk)
    end
  end

  def set_point_from_postcode
    return if postcode.blank? || point.present?

    geocode = PostcodeGeocoder.new(postcode)
    return unless geocode.valid?

    self.point = {
      type: 'Point',
      coordinates: geocode.coordinates
    }
  end
end
