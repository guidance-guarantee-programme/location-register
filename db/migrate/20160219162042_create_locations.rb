class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :uid
      t.string :organisation
      t.string :title
      t.string :address
      t.string :phone
      t.string :hours, limit: 500
      t.string :booking_location
      t.string :state, default: 'pending' # old, current, pending, closed
      t.datetime :closed_at
      t.integer :version
      t.jsonb :raw

      t.timestamps null: false
    end
  end
end
