class AddSuperAdminToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :super_admin, :boolean, default: false
  end
end
