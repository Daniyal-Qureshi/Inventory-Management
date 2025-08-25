require 'rails_helper'

RSpec.describe RestockReturnedProduct do
  let(:employee) { create(:employee) }
  let(:product) { create(:product) }
  let(:order) { create(:order) }
  let!(:returned_inventory_1) { create(:inventory, product:, status: :returned, order:) }
  let!(:returned_inventory_2) { create(:inventory, product:, status: :returned, order:) }

  describe '.run' do
    it 'changes returned inventory status to on_shelf' do
      RestockReturnedProduct.run(employee, product)

      expect(returned_inventory_1.reload.status).to eq('on_shelf')
      expect(returned_inventory_2.reload.status).to eq('on_shelf')
    end

    it 'creates inventory status changes' do
      expect do
        RestockReturnedProduct.run(employee, product)
      end.to change(InventoryStatusChange, :count).by(2)

      status_changes = InventoryStatusChange.last(2)
      status_changes.each do |status_change|
        expect(status_change.status_from).to eq('returned')
        expect(status_change.status_to).to eq('on_shelf')
        expect(status_change.actor).to eq(employee)
      end
    end

    it 'updates the product on_shelf counter' do
      product.update_on_shelf_counter
      expect(product.reload.on_shelf).to eq(0) # Returned items don't count as on_shelf

      RestockReturnedProduct.run(employee, product)

      expect(product.reload.on_shelf).to eq(2) # Now they should count as on_shelf
    end

    it 'returns true when successful' do
      result = RestockReturnedProduct.run(employee, product)
      expect(result).to be true
    end

    context 'when there are no returned inventories' do
      before do
        returned_inventory_1.update!(status: :on_shelf)
        returned_inventory_2.update!(status: :on_shelf)
      end

      it 'returns false' do
        result = RestockReturnedProduct.run(employee, product)
        expect(result).to be false
      end

      it 'does not create any inventory status changes' do
        expect do
          RestockReturnedProduct.run(employee, product)
        end.not_to change(InventoryStatusChange, :count)
      end
    end
  end
end
