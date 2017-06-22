class CreateAddresses < ActiveRecord::Migration[4.2]
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
