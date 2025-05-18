class AddRoleToEmployees < ActiveRecord::Migration[7.0]
  def change
    add_column :employees, :role, :integer, default: 0, null: false
  end
end
