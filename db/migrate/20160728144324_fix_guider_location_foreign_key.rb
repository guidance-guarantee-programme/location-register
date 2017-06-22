class FixGuiderLocationForeignKey < ActiveRecord::Migration[4.2]
  def change
    remove_foreign_key :guiders, :locations
  end
end
