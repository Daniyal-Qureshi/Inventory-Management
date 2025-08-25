RSpec.describe ShipInventory do
  let(:employee) { create(:employee) }
  let(:product) { create(:product) }
  let!(:inventory_1) { create(:inventory, product:, status: :on_shelf) }
  let!(:inventory_2) { create(:inventory, product:, status: :on_shelf) }
  let(:order) { create(:order) }

  it 'decreases on_shelf count after shipping inventory' do
    product.update_on_shelf_counter
    expect(product.reload.on_shelf).to eq(2)

    ShipInventory.run(employee, [inventory_1], order)

    expect(product.reload.on_shelf).to eq(1)
  end
end
