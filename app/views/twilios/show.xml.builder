xml.instruct!
xml.Response do
  xml.Dial do
    xml.Number @twilio_redirection.phone, @twilio_redirection.phone_options
  end
end
