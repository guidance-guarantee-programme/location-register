class SplitAddressComponents < ActiveRecord::Migration[4.2]
  def change
    add_column :addresses, "address_line_1",  :string
    add_column :addresses, "address_line_2",  :string
    add_column :addresses, "address_line_3",  :string
    add_column :addresses, "town",  :string
    add_column :addresses, "county",  :string
    add_column :addresses, "postcode",  :string
  end
end
