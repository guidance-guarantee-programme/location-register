class CreateCallCentres < ActiveRecord::Migration
  def up
    create_table :call_centres do |t|
      t.string :uid
      t.string :purpose
      t.string :twilio_number
      t.string :phone

      t.timestamps null: false
    end

    CallCentre.create!(
      uid: 'WtblVh6mT5eHmQY7QPWtOgA',
      purpose: 'Video promotion experiment - show video',
      twilio_number: '+448008021074',
      phone: '+442037333495'
    )

    CallCentre.create!(
      uid: 'WtblVh6mT5eHmQY7QPWtOgB',
      purpose: 'Video promotion experiment - hide video',
      twilio_number: '+448008021064',
      phone: '+442037333495'
    )

    CallCentre.create!(
      uid: 'WtblVh6mT5eHmQY7QPWtOgC',
      purpose: '50+ magazine experiment',
      twilio_number: '+448000119029',
      phone: '+442037333495'
    )
  end

  def down
    drop_table :call_centres
  end
end
