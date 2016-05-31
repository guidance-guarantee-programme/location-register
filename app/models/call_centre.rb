class CallCentre < ActiveRecord::Base
  validates :uid, presence: true
  validates :purpose, presence: true
  validates :phone, uk_phone_number: true
  validates :twilio_number,
            uniqueness: true,
            uk_phone_number: true
end
