require 'rails_helper'

RSpec.describe NeededInventoryQuery do
  it 'returns needed inventory counts per product for unfulfilled orders' do
    product = create(:product)
    other_product = create(:product)
    employee = create(:employee)
    ReceiveProduct.run(employee, product, 10)
    ReceiveProduct.run(employee, other_product, 10)

    order_products({ product => 5 })

    expect(NeededInventoryQuery.new(product).quantity).to eq 0
    expect(NeededInventoryQuery.new(other_product).quantity).to eq 0

    FindFulfillableOrder.begin_fulfillment(employee)

    expect(NeededInventoryQuery.new(product).quantity).to eq 0
    expect(NeededInventoryQuery.new(other_product).quantity).to eq 0

    order_products({ product => 5 })

    expect(NeededInventoryQuery.new(product).quantity).to eq 0
    expect(NeededInventoryQuery.new(other_product).quantity).to eq 0

    order_products({ product => 5 })

    expect(NeededInventoryQuery.new(product).quantity).to eq 5
    expect(NeededInventoryQuery.new(other_product).quantity).to eq 0
  end

  def order_products(products)
    create(:order).tap do |order|
      products.each do |product, quantity|
        create(:order_line_item, order: order, product: product, quantity: quantity)
      end
    end
  end
end
