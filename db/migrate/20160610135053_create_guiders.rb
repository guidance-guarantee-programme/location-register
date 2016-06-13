class CreateGuiders < ActiveRecord::Migration
  def change
    create_table :guiders do |t|
      t.string :name, null: false, default: ''
      t.string :email, null: false, default: ''
      t.references :location, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
