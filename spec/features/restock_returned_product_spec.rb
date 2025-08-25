require 'rails_helper'

RSpec.describe RestockReturnedProduct do
  let(:employee) { create(:employee, :warehouse) }
  let(:product) { create(:product) }

  describe '.run' do
    context 'when there are returned inventories' do
      let!(:returned_inventory_1) { create(:inventory, product:, status: :returned) }
      let!(:returned_inventory_2) { create(:inventory, product:, status: :returned) }

      it 'restocks all returned inventories' do
        expect do
          described_class.run(employee, product)
        end.to change { InventoryStatusChange.count }.by(2)

        expect(returned_inventory_1.reload.status).to eq('on_shelf')
        expect(returned_inventory_2.reload.status).to eq('on_shelf')
        expect(returned_inventory_1.reload.order_id).to be_nil
      end

      it 'updates product on_shelf count' do
        expect(product).to receive(:update_on_shelf_counter)
        described_class.run(employee, product)
      end
    end

    context 'when there are no returned inventories' do
      it 'does nothing and returns false' do
        expect(described_class.run(employee, product)).to eq(false)
        expect(InventoryStatusChange.count).to eq(0)
      end
    end
  end
end
