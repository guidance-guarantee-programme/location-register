# frozen_string_literal: true
# rubocop: disable Metrics/ClassLength
class Location < ApplicationRecord
  EDIT_FIELDS = %w[
    address_id
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
    realtime
    accessibility_information
  ].freeze
  TP_CALL_CENTRE_NUMBER = '+442037333495'
  ORGANISATIONS = %w[cas cita_e cita_w nicab].freeze

  belongs_to :address, validate: true
  belongs_to :booking_location, -> { current },
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
  validates :address, presence: true
  validates :booking_location, presence: { if: ->(l) { l.phone.blank? } }
  validates :version, presence: true
  validates :state, presence: true, inclusion: %w[old current]
  validates :phone,
            presence: { if: ->(l) { l.booking_location.blank? } },
            uk_phone_number: { if: :current_with_phone_number? }
  validates :hours, absence: { if: ->(l) { l.booking_location.present? } }
  validates :twilio_number,
            uk_phone_number: true,
            if: :current_with_twilio_number?
  validates :online_booking_twilio_number,
            presence: true,
            uk_phone_number: { allow_blank: true },
            unless: :booking_location_uid?,
            if: :online_booking_enabled?
  validates :hidden, inclusion: { in: [true], if: ->(l) { l.twilio_number.blank? } }
  validates :online_booking_enabled, inclusion: { in: [true, false] }
  validates :realtime, inclusion: { in: [true, false] }
  validates :accessibility_information, allow_blank: true, length: { maximum: 150 }

  default_scope -> { order(:title) }
  scope :current, -> { where(state: 'current') }
  scope :active, -> { where(hidden: false) }
  scope :current_by_visibility, -> { current.reorder(:hidden, :title) }
  scope :online_booking_enabled, -> { where(online_booking_enabled: true) }

  class << self
    def booking_location_for(uid)
      location = includes(:locations, :guiders)
                 .current
                 .find_by(uid: uid)

      location&.canonical_location
    end

    def between(start_time, end_time)
      where(created_at: start_time...end_time)
    end

    def booking_locations
      current.active.where(booking_location_uid: [nil, ''])
    end

    def externally_visible(include_hidden_locations:)
      scope = current.includes(:address, :booking_location)
      scope = scope.active unless include_hidden_locations
      scope
    end

    def with_visibility_flags(hidden_flags)
      current
        .where(hidden: hidden_flags)
        .includes(:address, :editor, :booking_location)
        .references(:address, :editor, :booking_location)
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

  def current_version
    self.class.current.find_by(uid: uid)
  end

  def matches_params?(params)
    EDIT_FIELDS.all? do |field_name|
      !params.key?(field_name) || params[field_name].to_s == self[field_name].to_s
    end
  end

  def current?
    state == 'current'
  end

  def current_with_phone_number?
    current? && booking_location.nil? && phone.present?
  end

  def current_with_twilio_number?
    current? && twilio_number.present?
  end

  def address_line
    address.to_a.join(', ')
  end

  def can_take_online_bookings?
    online_booking_enabled? && operational?
  end

  def cut_off?
    cut_off_from? && Time.zone.today >= cut_off_from
  end

  def operational?
    !cut_off?
  end

  def canonical_online_booking_twilio_number
    if online_booking_twilio_number.present?
      online_booking_twilio_number
    elsif booking_location_uid?
      booking_location.online_booking_twilio_number
    else
      ''
    end
  end
end
# rubocop: enable Metrics/ClassLength
