module TwilioRedirection
  class Location
    delegate :title, to: :@location

    def initialize(location)
      @location = location
    end

    def phone
      return ::Location::TP_CALL_CENTRE_NUMBER if redirect_to_call_center?

      recipient_location.phone
    end

    def phone_options
      return {} if recipient_location.extension.blank?

      { sendDigits: recipient_location.extension }
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
