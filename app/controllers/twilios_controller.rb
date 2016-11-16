class TwiliosController < ApplicationController
  protect_from_forgery with: :null_session

  def show
    if params[:To].blank?
      head :bad_request
    else
      @twilio_redirection = TwilioRedirection.for(params[:To])
      if @twilio_redirection
        render :show, formats: :xml
      else
        head(:not_found)
      end
    end
  end

  def handle_status
    twilio_number = params[:Called]
    @location_name = TwilioRedirection.for(twilio_number)&.title

    if params[:DialCallStatus] == 'failed'
      message = if twilio_number.present?
                  "Call forwarding failed for: '#{@location_name || 'Unknown Location'}' (#{twilio_number})"
                else
                  "Call forwarding failed for: 'No forwarding number'"
                end
      Bugsnag.notify(message)
    end

    render :handle_status, formats: :xml
  end
end
