class Location < ActiveRecord::Base
  EDIT_FIELDS = %w(address_id booking_location_uid hidden hours organisation phone title uid).freeze

  belongs_to :address
  belongs_to :booking_location, -> { current },
             foreign_key: :booking_location_uid,
             primary_key: :uid,
             class_name: 'Location'
  belongs_to :editor, class_name: 'User'

  validates :uid, presence: true
  validates :organisation, presence: true
  validates :title, presence: true
  validates :address, presence: true
  validates :phone, presence: true, if: ->(l) { l.booking_location.blank? }
  validates :booking_location, presence: true, if: ->(l) { l.phone.nil? }
  validates :version, presence: true
  validates :state, presence: true, inclusion: %w(old current)

  default_scope -> { order(:title) }
  scope :current, -> { where(state: 'current') }

  def initialize(*args)
    super
    self.uid ||= SecureRandom.uuid
  end

  def changed_edit_fields?(other)
    EDIT_FIELDS.any? do |field_name|
      other.key?(field_name) && other[field_name] != self[field_name]
    end
  end
end
