class CreateGuiderAssignments < ActiveRecord::Migration[5.0]
  def up
    create_table :guider_assignments do |t|
      t.belongs_to :guider, null: false
      t.belongs_to :location, null: false
      t.timestamps null: false

      t.index %i(guider_id location_id), unique: true
    end

    say_with_time 'Creating the necessary guider assignments' do
      Guider.pluck(:id, :location_id).each do |attributes|
        GuiderAssignment.create!(
          guider_id: attributes.first,
          location_id: attributes.last
        )
      end
    end
  end

  def down
    drop_table :guider_assignments
  end
end
