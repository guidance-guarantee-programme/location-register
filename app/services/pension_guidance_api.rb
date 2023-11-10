require 'faraday'
require 'faraday_middleware'

class PensionGuidanceApi
  def call
    connection.delete
  end

  private

  def connection
    @connection ||= Faraday.new(connection_options) do |faraday|
      faraday.response :raise_error
      faraday.use      :instrumentation
      faraday.adapter  Faraday.default_adapter
      faraday.authorization :Token, token if token
    end
  end

  def connection_options
    {
      url: "#{uri}/locations_cache",
      request: {
        timeout:      ENV.fetch('PENSION_GUIDANCE_TIMEOUT', 2).to_i,
        open_timeout: ENV.fetch('PENSION_GUIDANCE_OPEN_TIMEOUT', 2).to_i
      }
    }
  end

  def uri
    ENV.fetch('PENSION_GUIDANCE_URI') { 'http://localhost:3000' }
  end

  def token
    ENV['PENSION_GUIDANCE_TOKEN']
  end
end
