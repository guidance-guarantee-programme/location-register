class FixGuiderLocationForeignKey < ActiveRecord::Migration
  def change
    remove_foreign_key :guiders, :locations
  end
end
