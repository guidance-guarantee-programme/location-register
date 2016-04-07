class VisibilityFieldDecorator < SimpleDelegator
  def field
    'visibility'
  end

  def from
    wrap(super)
  end

  def to
    wrap(super)
  end

  private

  def wrap(value)
    return '' if value.nil?
    value ? 'Hidden' : 'Active'
  end
end
