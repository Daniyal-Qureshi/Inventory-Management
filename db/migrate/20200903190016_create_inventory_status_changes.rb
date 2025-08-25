class CreateInventoryStatusChanges < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE inventory_statuses AS ENUM ('on_shelf', 'shipped');
    SQL

    create_table :inventory_status_changes do |t|
      t.belongs_to :inventory, null: false, foreign_key: true
      t.column :status_from, :inventory_statuses
      t.column :status_to, :inventory_statuses, null: false
      t.belongs_to :actor, foreign_key: { to_table: :employees }
      t.timestamps
    end

    add_column :inventories, :status, :inventory_statuses, null: false
    add_index :inventories, :status
  end

  def down
    drop_table :inventory_status_changes
    remove_column :inventories, :status

    execute 'DROP TYPE inventory_statuses;'
  end
end
