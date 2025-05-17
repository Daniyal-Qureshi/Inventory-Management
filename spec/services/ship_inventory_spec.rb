RSpec.describe ShipInventory do
  let(:employee) { create(:employee) }
  let(:product) { create(:product) }
  let!(:inventory1) { create(:inventory, product: product, status: :on_shelf) }
  let!(:inventory2) { create(:inventory, product: product, status: :on_shelf) }
  let(:order) { create(:order) }

  it "decreases on_shelf count after shipping inventory" do
    product.update_on_shelf_counter
    expect(product.reload.on_shelf).to eq(2)

    ShipInventory.run(employee, [inventory1], order)

    expect(product.reload.on_shelf).to eq(1)
  end
end
