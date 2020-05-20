class CreateBuildings < ActiveRecord::Migration[6.0]
  def change
    create_table :buildings do |t|
      t.string :building_name
      t.string :super_name
      t.string :super_email
      t.integer :zipcode
      t.string :city
      t.string :province
      t.string :country
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
