class CreateEmployees < ActiveRecord::Migration[6.0]
  def change
    create_table :employees do |t|
      t.string :name, null: false
      t.string :access_code, limit: 5, null: false

      t.timestamps
    end

    add_index :employees, :access_code, unique: true
  end
end
