class AddAddressFixedToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :address_fixed, :boolean, default: false, null: false
  end
end
