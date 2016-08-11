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
end
