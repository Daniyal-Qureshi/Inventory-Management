class AddressesController < ApplicationController
  before_action :require_customer_service_employee
  before_action :set_order
  
  def update
    address = @order.ships_to
    
    if address.update(address_params)
      @order.mark_address_as_fixed! unless @order.address_fixed?
      redirect_to customer_service_index_path, notice: "Address has been updated successfully"
    else
      redirect_to customer_service_index_path, alert: "Error updating address: #{address.errors.full_messages.join(', ')}"
    end
  end
  
  private
  
  def set_order
    @order = Order.find(params[:order_id])
  end
  
  def address_params
    params.permit(:recipient, :street_1, :street_2, :city, :state, :zip)
  end
end 