class BookingLocationFieldDecorator < SimpleDelegator
  def from
    wrap(super)
  end

  def to
    wrap(super)
  end

  private

  def wrap(value)
    return '' if value.nil?
    value.title
  end
end
