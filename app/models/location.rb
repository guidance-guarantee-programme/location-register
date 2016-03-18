class Location < ActiveRecord::Base
  include CurieLookup

  curie_lookup :address, :booking_location

  validates :uid, presence: true
  validates :organisation, presence: true
  validates :title, presence: true
  validates :address, presence: true
  validates :hours, presence: true
  validates :phone, presence: true, if: ->(a){ a.booking_location.blank? }
  validates :booking_location, presence: true, if: ->(a){ a.phone.blank? }
  validates :version, presence: true
  validates :state, presence: true, inclusion: %w(old current)

  def initialize(*args)
    super
    self.uid ||= SecureRandom.uuid
  end
end
