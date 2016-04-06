class EditedLocation < SimpleDelegator
  class << self
    def all(locations)
      locations.group_by(&:uid).map do |_uid, edited_locations|
        new(edited_locations)
      end
    end
  end

  attr_reader :edits

  def initialize(edited_locations)
    super(edited_locations.sort_by(&:created_at).last)
    @edits = edited_locations.flat_map(&method(:edited_fields))
                             .sort_by(&method(:sort_order))
  end

  private

  def edited_fields(location)
    previous_location = Location.find_by(uid: location.uid, version: location.version - 1)
    EditedLocationField.all(location, previous_location)
  end

  def sort_order(edit)
    [edit.field, edit.created_at]
  end
end
