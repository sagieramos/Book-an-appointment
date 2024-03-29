class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :city

      t.timestamps
    end
    add_index :users, :username, unique: true
  end
end
