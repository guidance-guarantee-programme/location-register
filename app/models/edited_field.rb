class EditedField
  attr_accessor :field

  def initialize(field, location, old_location)
    @field = field.to_s
    @location = location
    @old_location = old_location
  end

  def new_value
    @location.public_send(@field)
  end

  def old_value
    @old_location&.public_send(@field)
  end

  def action
    @old_location ? 'edit' : 'create'
  end

  def created_at
    @location.created_at.localtime
  end

  def editor
    @location.editor
  end

  def changed?
    (old_value.present? || new_value.present?) && old_value != new_value
  end
end
