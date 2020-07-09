namespace :export do
  desc 'Export CSV data to blob storage for analysis'
  task blob: :environment do
    from_timestamp = ENV.fetch('FROM') { 3.months.ago }

    Location.public_send(:acts_as_copy_target)

    data = Location
           .current
           .active
           .where('created_at >= ? or updated_at >= ?', from_timestamp, from_timestamp)
           .select('uid, title, created_at, updated_at')
           .order(:created_at)
           .copy_to_string

    client = Azure::Storage::Blob::BlobService.create_from_connection_string(
      ENV.fetch('AZURE_CONNECTION_STRING')
    )

    client.create_block_blob(
      'pw-prd-data',
      "/To_Be_Processed/MAPS_PWBLZ_LOCATIONS_#{Time.current.strftime('%Y%m%d%H%M%S')}.csv",
      data
    )
  end
end
