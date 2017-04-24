# frozen_string_literal: true
class Location < ApplicationRecord # rubocop: disable Metrics/ClassLength
  EDIT_FIELDS = %w(
    booking_location_uid
    hidden
    hours
    organisation
    phone
    title
    uid
    extension
    twilio_number
    online_booking_twilio_number
    online_booking_enabled
    online_booking_reply_to
    address_line_1,
    address_line_2,
    address_line_3,
    town,
    county,
    postcode
  ).freeze
  TP_CALL_CENTRE_NUMBER = '+442037333495'
  ORGANISATIONS = %w(cas cita nicab).freeze

  belongs_to :booking_location,
             foreign_key: :booking_location_uid,
             primary_key: :uid,
             class_name: 'Location'
  belongs_to :editor, class_name: 'User'
  has_many :locations, foreign_key: :booking_location_uid, primary_key: :uid

  has_many :guider_assignments
  has_many :guiders, through: :guider_assignments

  validates :uid, presence: true
  validates :organisation, presence: true, inclusion: ORGANISATIONS
  validates :title, presence: true
  validates :booking_location, presence: { if: ->(l) { l.phone.blank? } }
  validates :phone,
            presence: { if: ->(l) { l.booking_location.blank? } },
            uk_phone_number: { if: :with_phone_number? }
  validates :hours, absence: { if: ->(l) { l.booking_location.present? } }
  validates :twilio_number,
            uniqueness: true,
            uk_phone_number: true,
            if: :twilio_number?
  validates :online_booking_twilio_number,
            presence: true,
            uk_phone_number: { allow_blank: true },
            unless: :booking_location_uid?,
            if: :online_booking_enabled?
  validates :hidden, inclusion: { in: [true], if: ->(l) { l.twilio_number.blank? } }
  validates :online_booking_enabled, inclusion: { in: [true, false] }
  validates :postcode, :address_line_1, presence: true
  validate :valid_uk_postcode

  before_validation :set_point_from_postcode

  default_scope -> { order(:title) }
  scope :active, -> { where(hidden: false) }
  scope :by_visibility, -> { reorder(:hidden, :title) }

  class << self
    def booking_location_for(uid)
      location = includes(:locations, :guiders)
                 .find_by(uid: uid)

      location&.canonical_location
    end

    def between(start_time, end_time)
      where(created_at: start_time...end_time)
    end

    def booking_locations
      active.where(booking_location_uid: nil)
    end

    def externally_visible(include_hidden_locations:)
      scope = includes(:booking_location)
      scope = scope.active unless include_hidden_locations
      scope
    end

    def with_visibility_flags(hidden_flags)
      where(hidden: hidden_flags)
        .includes(:editor, :booking_location)
        .references(:editor, :booking_location)
    end

    def latest_for_twilio_number
      reorder(:hidden, 'updated_at DESC', 'created_at DESC')
        .each_with_object({}) do |location, hash|
          next if location.twilio_number.blank?
          hash[location.twilio_number] ||= location
          hash[location.online_booking_twilio_number] ||= location if location.online_booking_twilio_number.present?
        end
    end
  end

  def initialize(*args)
    super
    self.uid ||= SecureRandom.uuid
  end

  def canonical_location
    booking_location || self
  end

  def matches_params?(params)
    EDIT_FIELDS.all? do |field_name|
      !params.key?(field_name) || params[field_name].to_s == self[field_name].to_s
    end
  end

  # FIX - this is validating more than it says on the tin
  def with_phone_number?
    booking_location.nil? && phone.present?
  end

  def address_lines
    [
      address_line_1,
      address_line_2,
      address_line_3,
      town,
      county,
      postcode
    ].map(&:presence).compact
  end

  def address_line
    address_lines.compact
  end

  def slots
    Slot.all(cut_off_from, cut_off_to)
  end

  def can_take_online_bookings?
    online_booking_enabled? && BANK_HOLIDAYS.exclude?(Time.zone.today) && operational?
  end

  def cut_off?
    cut_off_from? && Time.zone.today >= cut_off_from
  end

  def operational?
    !cut_off?
  end

  def valid_uk_postcode
    return if postcode.blank?

    uk_postcode = UKPostcode.parse(postcode)
    if uk_postcode.full_valid?
      errors.add(:postcode, :geocoding_error) unless point.present?
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
