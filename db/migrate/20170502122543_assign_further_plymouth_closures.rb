class AssignFurtherPlymouthClosures < ActiveRecord::Migration[5.0]
  def up
    Location
      .current
      .where('uid = :uid or booking_location_uid = :uid', uid: 'c312229b-c96d-49d0-8362-4a3f746b3ac4')
      .update_all(cut_off_to: '2017-05-22')
  end

  def down
    # noop
  end
end
