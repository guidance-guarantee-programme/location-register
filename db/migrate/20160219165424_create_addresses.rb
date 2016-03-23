class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :uid
      t.string :name
      t.string :address
      t.jsonb :point

      t.timestamps null: false
    end
  end
end
