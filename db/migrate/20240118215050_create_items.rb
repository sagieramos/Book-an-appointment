class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.references :admin, null: false, foreign_key: { to_table: 'users' }
      t.string :name
      t.binary :image
      t.text :description
      t.string :city

      t.timestamps
    end
  end
end
