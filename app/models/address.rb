class Address < ActiveRecord::Base
  def initialize(*args)
    super
    self.uid ||= SecureRandom.uuid
  end

  def to_a
    [
      address_line_1,
      address_line_2,
      address_line_3,
      town,
      county,
      postcode
    ].map(&:presence).compact
  end
end
