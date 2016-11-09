xml.instruct!
xml.Response do
  xml.Dial(action: twilio_handle_status_url, method: 'GET') do
    xml.Number @twilio_redirection.phone, @twilio_redirection.phone_options
  end
end
