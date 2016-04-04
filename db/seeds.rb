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

def get_address(params, state)
  address = Address.find_by(uid: params['uid'])
  address.update_attributes(params) if address && state == 'current'
  address || Address.create!(params)
end

File.open(Rails.root.join('db/seeds/locations.json')) do |f|
  while !f.eof? do
    print '.'
    line = f.readline
    location_params = JSON.parse(line)
    address_params = location_params.delete('address')

    address = get_address(address_params, location_params['state'])

    # as some of the historical data does not meet new validation requirements
    location = Location.new(location_params.merge(address: address))
    location.save!(validate: location_params['state'] == 'current')
  end
end
puts ''
