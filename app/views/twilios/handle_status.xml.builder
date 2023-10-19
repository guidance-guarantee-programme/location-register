xml.instruct!
xml.Response do
  case params['DialCallStatus']
  when 'busy', 'failed'
    xml.Say(
      "Thank you for calling Pension Wise #{@location_name}.
      Sorry, but all our lines are busy, please call back later",
      voice: ENV.fetch('VOICE', 'alice'),
      language: ENV.fetch('VOICE_LANGUAGE', 'en-GB')
    )
  when 'no-answer'
    xml.Say(
      "Thank you for calling Pension Wise #{@location_name}.
      Sorry, but there's no one available to take your call right now, please call back later",
      voice: ENV.fetch('VOICE', 'alice'),
      language: ENV.fetch('VOICE_LANGUAGE', 'en-GB')
    )
  end
end
