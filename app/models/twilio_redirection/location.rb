module TwilioRedirection
  class Location
    delegate :title, to: :@location

    def initialize(location)
      @location = location
    end

    def phone
      if redirect_to_call_center?
        ::Location::TP_CALL_CENTRE_NUMBER
      else
        recipient_location.phone
      end
    end

    def phone_options
      if recipient_location.extension.blank?
        {}
      else
        { sendDigits: recipient_location.extension }
      end
    end

    private

    def redirect_to_call_center?
      [@location.booking_location, @location].compact.all?(&:hidden?)
    end

    def recipient_location
      @location.phone.present? ? @location : @location.booking_location
    end
  end
end
