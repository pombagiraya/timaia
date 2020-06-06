class ChangeZipcodeToBeStringInBuildings < ActiveRecord::Migration[6.0]
  def change
    change_column :buildings, :zipcode, :string
  end
end
