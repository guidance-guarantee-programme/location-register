class AddressFieldDecorator < SimpleDelegator
  def from
    wrap(super)
  end

  def to
    wrap(super)
  end

  private

  def wrap(value)
    return '' if value.nil?
    value.to_a.join('<br/>').html_safe
  end
end
