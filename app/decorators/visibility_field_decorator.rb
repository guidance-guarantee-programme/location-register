class VisibilityFieldDecorator < SimpleDelegator
  def field
    'visibility'
  end

  def old_value
    wrap(super)
  end

  def new_value
    wrap(super)
  end

  private

  def wrap(value)
    return '' if value.nil?
    value ? 'Hidden' : 'Active'
  end
end
