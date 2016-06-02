require 'yaml'

class AddTwilioNumberToLocation < ActiveRecord::Migration
  def up
    add_column :locations, :twilio_number, :string
    add_column :locations, :extension, :string

    Location.reset_column_information

    ActiveRecord::Base.transaction do
      # set the twilio numbers
      redirects = YAML.load(File.read(Rails.root.join('db/migrate/redirects.yaml')))
      twilio_lookup = redirects.each_with_object({}) do |r, h|
        h[r['id']] = r
      end

      Location.current.each do |location|
        changes = {}

        if location.phone =~ /ext/
          phone, ext = *location.phone.split('ext')
          changes['extension'] = ext.strip
          changes['phone'] = phone.strip
        end

        if location.phone.present? && location.phone !~ /\A\+44/
          changes['phone'] = (changes['phone'] || location.phone).delete(' ').gsub(/\A0/, '+44')
        end

        if twilio_number = twilio_lookup.delete(location.uid)
          changes['twilio_number'] = '+' + twilio_number['twilio'].to_s
        else
          location.hidden || puts("No twilio number for: #{location.title}")
        end

        updater = UpdateLocation.new(location: location, user: User.find_by(email: 'david.henry@pensionwise.gov.uk'))

        if changes.any? && (updater.update(changes) == location)
          raise "Errors: #{location.errors.full_messages.join(', ')}"
        end
      end

      puts 'The following redirects do not have a location'
      puts twilio_lookup.inspect
    end
  end

  def down
    Location.where.not(extension: '').each do |location|
      location.phone << ' ext ' << location.extension
      location.save(validate: false)
    end

    remove_column :locations, :twilio_number
    remove_column :locations, :extension
  end
end
