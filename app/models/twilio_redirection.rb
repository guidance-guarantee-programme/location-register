class TwilioRedirection
  def self.for(twilio_number)
    Location.lookup_current(twilio_number) || Location.lookup_old(twilio_number) || CallCentre.lookup(twilio_number)
  end

  class Location
    def self.lookup_current(twilio_number)
      location = ::Location.current.find_by(twilio_number: twilio_number)
      location ? new(location.canonical_location) : nil
    end

    def self.lookup_old(twilio_number)
      location = ::Location.order('created_at DESC').find_by(twilio_number: twilio_number)&.current_version
      location ? new(location.canonical_location) : nil
    end

    def initialize(location)
      @location = location
    end

    delegate :title, to: :@location

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
    def self.lookup(twilio_number)
      call_centre = ::CallCentre.find_by(twilio_number: twilio_number)
      call_centre ? CallCentre.new(call_centre) : nil
    end

    def title
      ''
    end

    def phone_options
      {}
    end
  end
end
