namespace :location do
  desc 'Create a new location'
  task create: :environment do
    class MissingParamError < StandardError; end

    begin
      user = User.find_by!(email: ENV['USER_EMAIL'] || raise(MissingParamError))

      params = {
        hidden: true,
        organisation: ENV['ORGANISATION'] || raise(MissingParamError),
        booking_location_uid: ENV['BOOKING_LOCATION_UID'],
        title: ENV['TITLE'] || raise(MissingParamError),
        address: {
          address_line_1: ENV['ADDRESS_LINE_1'] || raise(MissingParamError),
          address_line_2: ENV['ADDRESS_LINE_2'],
          address_line_3: ENV['ADDRESS_LINE_3'],
          town: ENV['TOWN'],
          county: ENV['COUNTY'],
          postcode: ENV['POSTCODE'] || raise(MissingParamError)
        }
      }
    rescue MissingParamError
      puts 'Missing parameter.'
      puts 'Example usage:'
      puts(
        'USER_EMAIL=developer@pensionwise.gov.uk ORGANISATION=cita ' /
        'BOOKING_LOCATION_UID="91b67ee6-f131-44d1-a05e-aac1306adba4" TITLE="Garforth" ' /
        'ADDRESS_LINE_1="Garforth Library and One Stop Centre" POSTCODE="RH1 6EW" bundle exec rake location:create'
      )
      exit 0
    end

    puts 'About to creating new location:'
    pp params
    puts 'Continue: y/n'
    exit 0 unless STDIN.getc == 'y'

    updater = CreateLocation.new(user: user)
    new_location = updater.create(params.with_indifferent_access)
    result = {
      '#' => new_location.title,
      'id' => new_location.uid,
      'twilio' => nil,
      'cab' => new_location.booking_location.phone
    }
    puts([result].to_yaml)
  end
end
