class Location < ActiveRecord::Base
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
end
