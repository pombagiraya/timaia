class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.string :name
      t.references :building, null: false, foreign_key: true
      t.float :price

      t.timestamps
    end
  end
end
