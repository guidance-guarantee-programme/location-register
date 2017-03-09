class CorrectHiddenCurrentLocations < ActiveRecord::Migration[5.0]
  def up
    Location.current.where(hidden: true).update_all(state: 'old')
  end

  def down
    # noop
  end
end
