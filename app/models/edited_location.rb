class EditedLocation
  FIELDS = {
    organisation: EditedField,
    title: EditedField,
    address: EditedField::AddressField,
    phone: EditedField,
    extension: EditedField,
    hours: EditedField,
    hidden: EditedField::VisibilityField,
    twilio_number: EditedField,
    booking_location: EditedField::BookingLocationField,
    online_booking_twilio_number: EditedField,
    online_booking_enabled: EditedField,
    realtime: EditedField,
    accessibility_information: EditedField
  }.freeze

  class << self
    def for(location)
      new(
        Location.includes(:address, :editor).where(uid: location.uid),
        sort: :desc
      ).edits
    end

    def all(locations)
      locations.group_by(&:uid).map do |_uid, edited_locations|
        new(edited_locations)
      end
    end
  end

  attr_reader :edits
  delegate :uid, :title, :booking_location, to: :current

  def initialize(versions, sort: :asc)
    @versions = versions
    @sort_direction_multiplier = sort == :desc ? -1 : 1
  end

  def edits
    @versions
      .flat_map { |location| edited_fields(location) }
      .sort_by { |location| [@sort_direction_multiplier * location.created_at.to_i, location.field] }
      .group_by(&:created_at)
  end

  private

  def current
    @current ||= @versions.sort_by(&:version).last
  end

  def edited_fields(location)
    old_location = @versions.detect { |version| version.version == location.version - 1 } ||
                   Location.find_by(uid: location.uid, version: location.version - 1)

    FIELDS
      .map { |field, klass| klass.new(field, location, old_location) }
      .select(&:changed?)
  end
end
