class CreateApartments < ActiveRecord::Migration[6.0]
  def change
    create_table :apartments do |t|
      t.string :name
      t.integer :apt_number
      t.decimal :bill, :precision => 8, :scale => 2
      t.references :building, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
