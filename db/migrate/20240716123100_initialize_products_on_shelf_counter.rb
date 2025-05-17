class InitializeProductsOnShelfCounter < ActiveRecord::Migration[7.0]
  def up
    # Initialize on_shelf counters with data from the view
    execute <<-SQL
      UPDATE products
      SET on_shelf = COALESCE((
        SELECT quantity 
        FROM product_on_shelf_quantities 
        WHERE product_on_shelf_quantities.product_id = products.id
      ), 0)
    SQL
  end

  def down
    # Reset all counters to 0
    execute("UPDATE products SET on_shelf = 0")
  end
end 