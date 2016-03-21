# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'json'
Address.delete_all
Location.delete_all

File.open(Rails.root.join('db/seeds/locations.json')) do |f|
  while (line = f.readline).present? do
    print '.'
    location_params = JSON.parse(line)
    address_params = location_params.delete('address')

    address = Address.find_by(uid: address_params['uid']) ||
      Address.create!(address_params)

    # as some of the historical data does not meet new validation requirements
    Location.new(location_params.merge(address: address))
      .save(validate: location_params['state'] == 'current')
    break if f.eof?
  end
end
puts ''
