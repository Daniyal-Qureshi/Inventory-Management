class AddReturnedAndPendingRestockToInventoryStatusesEnum < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      ALTER TYPE inventory_statuses ADD VALUE IF NOT EXISTS 'returned';
    SQL
  end

  def down
    puts 'Warning: Cannot remove values from an enum type in PostgreSQL'
  end
end
