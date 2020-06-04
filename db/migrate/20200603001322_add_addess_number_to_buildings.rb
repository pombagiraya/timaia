class AddAddessNumberToBuildings < ActiveRecord::Migration[6.0]
  def change
    add_column :buildings, :address_number, :string
  end
end
