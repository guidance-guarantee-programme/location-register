class UkPhoneNumberValidator < ActiveModel::EachValidator
  REGEXP = /\A\+44\d{9,10}\z/

  def validate_each(record, attribute, value)
    return if value.to_s =~ REGEXP
    record.errors.add(attribute, :invalid, options.dup.merge!(value: value))
  end
end
