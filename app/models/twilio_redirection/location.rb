module TwilioRedirection
  class Location
    delegate :title, to: :@location

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
end
