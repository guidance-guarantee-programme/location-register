class CallCentre < ActiveRecord::Base
  PHONE_NUMBER_REGEXP = /\A\+44\d{9,10}\z/

  validates :uid, presence: true
  validates :purpose, presence: true
  validates :phone, format: PHONE_NUMBER_REGEXP
  validates :twilio_number,
            uniqueness: true,
            format: PHONE_NUMBER_REGEXP
end
