class CreateOrderLineItems < ActiveRecord::Migration[6.0]
  def change
    create_table :order_line_items do |t|
      t.belongs_to :order, null: false
      t.belongs_to :product, null: false
      t.integer :quantity, null: false, default: 1
      t.timestamps
    end

    add_index :order_line_items, %i[order_id product_id], unique: true
  end
end
