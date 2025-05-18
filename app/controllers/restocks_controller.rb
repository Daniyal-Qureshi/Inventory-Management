class RestocksController < ApplicationController
  before_action :require_warehouse_employee

  def create
    product = Product.find(params[:product_id])
    RestockReturnedProduct.run(current_user, product)

    redirect_to employees_path, notice: 'Returned products have been restocked'
  end
end
