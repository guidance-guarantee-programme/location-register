# frozen_string_literal: true
class Location < ActiveRecord::Base
  EDIT_FIELDS = %w(
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
  ).freeze
  PHONE_NUMBER_REGEXP = /\A\+44\d{9,10}\z/
  TP_CALL_CENTRE_NUMBER = '+442037333495'

  belongs_to :address, validate: true
  belongs_to :booking_location, -> { current },
             foreign_key: :booking_location_uid,
             primary_key: :uid,
             class_name: 'Location'
  belongs_to :editor, class_name: 'User'

  validates :uid, presence: true
  validates :organisation, presence: true
  validates :title, presence: true
  validates :address, presence: true
  validates :booking_location, presence: { if: ->(l) { l.phone.nil? } }
  validates :version, presence: true
  validates :state, presence: true, inclusion: %w(old current)
  validates :phone,
            presence: { if: ->(l) { l.booking_location.blank? } },
            format: { with: PHONE_NUMBER_REGEXP, if: ->(l) { l.phone.present? && l.current? } }
  validates :twilio_number,
            uniqueness: { conditions: -> { current } },
            format: PHONE_NUMBER_REGEXP,
            if: ->(l) { l.twilio_number.present? && l.current? }

  default_scope -> { order(:title) }
  scope :current, -> { where(state: 'current') }
  scope :active, -> { where(hidden: false) }

  class << self
    def between(start_time, end_time)
      where(created_at: start_time...end_time)
    end

    def booking_locations
      current.active.where(booking_location_uid: nil)
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
  end

  def initialize(*args)
    super
    self.uid ||= SecureRandom.uuid
  end

  def matches_params?(params)
    EDIT_FIELDS.all? do |field_name|
      !params.key?(field_name) || params[field_name].to_s == self[field_name].to_s
    end
  end

  def current?
    state == 'current'
  end
end
