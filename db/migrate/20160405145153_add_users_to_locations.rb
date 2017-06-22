class AddUsersToLocations < ActiveRecord::Migration[4.2]
  def up
    add_reference :locations, :editor, references: :user

    if defined?(User)
      user = User.find_by!(email: 'david.henry@pensionwise.gov.uk')

      initial_deploy_date = Date.new(2016, 4, 3)

      Location.where(['created_at < ?', initial_deploy_date]).update_all(editor_id: user.id)

      Location.where(['created_at >= ?', initial_deploy_date]).each do |location|
        location.editor_id = User.find_by!(organisation_slug: location.organisation).id
        location.save!
      end
    end
  end

  def down
    remove_reference :locations, :editor
  end
end
