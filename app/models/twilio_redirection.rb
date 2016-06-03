class TwilioRedirection
  def self.for(twilio_number)
    Location.for(twilio_number) || CallCentre.for(twilio_number)
  end

  class Location
    def self.for(twilio_number)
      location = ::Location.current.find_by(twilio_number: twilio_number)
      location ? new(location.booking_location || location) : nil
    end

    def initialize(location)
      @location = location
    end

    def phone
      return ::Location::TP_CALL_CENTRE_NUMBER if @location.hidden?

      @location.phone
    end

    def phone_options
      return {} if @location.extension.blank?

      { sendDigits: @location.extension }
    end
  end

  class CallCentre < SimpleDelegator
    def self.for(twilio_number)
      call_centre = ::CallCentre.find_by(twilio_number: twilio_number)
      call_centre ? CallCentre.new(call_centre) : nil
    end

    def phone_options
      {}
    end
  end
end
