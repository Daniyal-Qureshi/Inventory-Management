class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.belongs_to :ships_to, foreign_key: { to_table: :addresses }
      t.timestamps
    end
  end
end
