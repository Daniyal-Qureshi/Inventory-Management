class CreateProductOnShelfQuantities < ActiveRecord::Migration[6.0]
  def change
    create_view :product_on_shelf_quantities
  end
end
