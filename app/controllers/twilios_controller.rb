class TwiliosController < ApplicationController
  def show
    if params[:To].blank?
      head :bad_request
    else
      @twilio_redirection = TwilioRedirection.for(params[:To])
      @twilio_redirection || head(:not_found)
    end
  end
end
