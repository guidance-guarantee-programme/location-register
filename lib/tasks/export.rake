namespace :export do
  desc 'Export CSV data to blob storage for analysis'
  task blob: :environment do
    Location.public_send(:acts_as_copy_target)

    data = Location.current.active.select('uid, title, created_at, updated_at').order(:created_at).copy_to_string

    client = Azure::Storage::Blob::BlobService.create_from_connection_string(
      ENV.fetch('AZURE_CONNECTION_STRING')
    )

    client.create_block_blob(
      'pw-prd-data',
      "MAPS_PWBLZ_LOCATIONS_#{Time.current.strftime('%Y%m%d%H%M%S')}.csv",
      data
    )
  end
end
