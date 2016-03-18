class Address < ActiveRecord::Base
  def initialize(*args)
    super
    self.uid ||= SecureRandom.uuid
  end
end
