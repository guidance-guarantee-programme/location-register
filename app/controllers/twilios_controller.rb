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
    twilio_redirection = TwilioRedirection.for(params[:Called]) if params[:Called].present?

    if twilio_redirection && params[:DialCallStatus] == 'failed'
      Bugsnag.notify("Invalid number detected for: '#{twilio_redirection.title}' (#{twilio_redirection.phone})")
    end

    @location_name = twilio_redirection&.title

    render :handle_status, formats: :xml
  end
end
