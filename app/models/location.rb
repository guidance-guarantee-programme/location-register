class Location < ActiveRecord::Base
  EDIT_FIELDS = %w(address_id booking_location_uid hidden hours organisation phone title uid).freeze

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

  def matches_params?(params)
    EDIT_FIELDS.all? do |field_name|
      !params.key?(field_name) || params[field_name].to_s == self[field_name].to_s
    end
  end
end
