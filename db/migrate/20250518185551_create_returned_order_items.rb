class CreateReturnedOrderItems < ActiveRecord::Migration[7.0]
  def change
    create_table :returned_order_histories do |t|
      t.references :product, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 1

      t.timestamps
    end
  end
end
