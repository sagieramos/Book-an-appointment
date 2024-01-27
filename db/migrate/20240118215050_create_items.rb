class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.references :admin, null: false, foreign_key: { to_table: 'users' }
      t.string :name
      t.binary :image
      t.text :description
      t.string :city
      t.decimal :finance_fee, precision: 10, scale: 2
      t.decimal :option_to_purchase_fee, precision: 10, scale: 2
      t.decimal :total_amount_payable, precision: 10, scale: 2
      t.integer :duration
      t.decimal :apr_representative, precision: 5, scale: 2

      t.timestamps
    end
  end
end
