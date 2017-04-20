class RemoveLocationStateAndVersion < ActiveRecord::Migration[5.0]
  def change
    remove_column :locations, :state
    remove_column :locations, :version
  end
end
