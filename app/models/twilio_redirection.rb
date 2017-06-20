module TwilioRedirection
  def self.for(twilio_number)
    lookup_current_location(twilio_number) || lookup_old_location(twilio_number) || lookup_call_centre(twilio_number)
  end

  def self.lookup_current_location(twilio_number)
    location = ::Location.current.find_by(twilio_number: twilio_number)
    location ? TwilioRedirection::Location.new(location) : nil
  end

  def self.lookup_old_location(twilio_number)
    location = ::Location.order('created_at DESC').find_by(twilio_number: twilio_number)&.current_version
    location ? TwilioRedirection::Location.new(location) : nil
  end

  def self.lookup_call_centre(twilio_number)
    call_centre = ::CallCentre.find_by(twilio_number: twilio_number)
    call_centre ? TwilioRedirection::CallCentre.new(call_centre) : nil
  end
end
