class AddHiddenFlag < ActiveRecord::Migration
  def change
    add_column :locations, :hidden, :boolean, default: false

    Location.where(state: 'hidden').each do |location|
      if Location.where(uid: location.uid, state: 'current').any?
        location.update_attributes!(state: 'old', hidden: true)
      else
        location.update_attributes!(state: 'current', hidden: true)
      end
    end
  end
end
