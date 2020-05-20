class RemoveNameFromApartments < ActiveRecord::Migration[6.0]
  def change
    remove_column :apartments, :name, :string
  end
end
