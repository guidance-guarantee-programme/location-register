Geocoder.configure(
  lookup: :google,
  use_https: true,
  api_key: ENV.fetch('GOOGLE_GEOCODER_API_KEY', '')
)
