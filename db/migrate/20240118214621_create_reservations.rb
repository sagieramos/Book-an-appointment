class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.references :customer, null: false, foreign_key: { to_table: 'users' }
      t.date :reserve_for_use_date

      t.timestamps
    end

    add_index :reservations, :reserve_for_use_date
  end
end
