class AddressFieldDecorator < SimpleDelegator
  def old_value
    wrap(super)
  end

  def new_value
    wrap(super)
  end

  private

  def wrap(value)
    return '' if value.nil?

    value.to_a.join('<br/>').html_safe
  end
end
