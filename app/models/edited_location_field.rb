class EditedLocationField
  EDITABLE_FIELDS = %w(title address phone hours booking_location hidden).freeze
  DECORATOR_LOOKUP = {
    'address' => AddressFieldDecorator,
    'booking_location' => BookingLocationFieldDecorator,
    'hidden' => VisibilityFieldDecorator
  }.freeze

  class << self
    def all(location, previous_location)
      edited_fields = EDITABLE_FIELDS.map do |field_name|
        new(
          field_name,
          location,
          previous_location
        )
      end

      edited_fields.select(&:changed?)
                   .map(&method(:decorate))
    end

    private

    def decorate(edited_field)
      decorator = DECORATOR_LOOKUP[edited_field.field]
      decorator ? decorator.new(edited_field) : edited_field
    end
  end

  attr_reader :created_at, :editor, :field, :from, :to

  def initialize(field, location, previous_location)
    @field = field
    @from = previous_location&.send(field)
    @to = location.send(field)
    @created_at = location.created_at.localtime
    @editor = location.editor
  end

  def changed?
    from != to
  end
end
