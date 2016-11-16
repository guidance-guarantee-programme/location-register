module TwilioRedirection
  class CallCentre < SimpleDelegator
    def title
      ''
    end

    def phone_options
      {}
    end
  end
end
