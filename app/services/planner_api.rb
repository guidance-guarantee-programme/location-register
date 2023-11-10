require 'faraday'
require 'faraday_middleware'

class PlannerApi
  def call(booking_location_id, location_id)
    connection.patch do |request|
      request.body = JSON.generate(
        booking_location_id: booking_location_id,
        location_id: location_id
      )
    end
  end

  private

  def connection
    @connection ||= Faraday.new(connection_options) do |faraday|
      faraday.request  :json
      faraday.response :raise_error
      faraday.use      :instrumentation
      faraday.adapter  Faraday.default_adapter
      faraday.authorization :Bearer, bearer_token if bearer_token
    end
  end

  def connection_options
    {
      url: "#{uri}/api/v1/booking_requests/batch_reassign",
      request: {
        timeout:      ENV.fetch('PLANNER_TIMEOUT', 2).to_i,
        open_timeout: ENV.fetch('PLANNER_OPEN_TIMEOUT', 2).to_i
      }
    }
  end

  def uri
    ENV.fetch('PLANNER_URI') { 'http://localhost:3002' }
  end

  def bearer_token
    ENV['PLANNER_BEARER_TOKEN']
  end
end
