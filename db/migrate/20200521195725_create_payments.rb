class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.date :payment_date
      t.integer :status
      t.references :apartment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
