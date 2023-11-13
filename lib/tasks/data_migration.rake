require 'csv'

# rubocop:disable Metrics/BlockLength
namespace :data_migration do
  desc 'Update locations so that words are sensibly cased'
  task update_locations_with_caps: :environment do
    UpdateLocationWithCaps.new('lib/tasks/address_without_caps.csv').update
  end

  class UpdateLocationWithCaps
    def initialize(path)
      @path = path
    end

    def update
      csv_data do |row|
        location = Location.current.find_by(uid: row['Location UID'])

        if location.nil?
          puts "Skipping: #{row['Location UID']}"
        else
          updater = CreateOrUpdateLocation.new(location: location, user: user)
          new_location = updater.update(params(row))

          new_record!(new_location)
          address_change!(location, new_location)

          sleep 1 # required to avoid geocoding limit
        end
      end
    end

    def csv_data(&block)
      CSV.parse(File.read(Rails.root.join(@path)), headers: true).each(&block)
    end

    def new_record!(location)
      return unless location.new_record?
      puts "Error updating address for: #{location.uid} - #{location.errors.full_messages}"
    end

    def address_change!(location1, location2)
      address1 = location1.address.to_a.join(', ')
      address2 = location2.address.to_a.join(', ')

      return if address1.casecmp(address2).zero?

      puts "Changed address for: #{location1.uid}"
      puts "  From: #{address1}"
      puts "  To:   #{address2}"
    end

    def user
      @user ||= User.find_by!(email: 'david.henry@pensionwise.gov.uk')
    end

    def params(row)
      {
        address: {
          address_line_1: row['line1'],
          address_line_2: row['line2'].presence,
          address_line_3: row['line3'].presence,
          town: row['town'].presence,
          county: row['county'].presence,
          postcode: row['post code']
        }.with_indifferent_access
      }.with_indifferent_access
    end
  end
end
# rubocop:enable Metrics/BlockLength
