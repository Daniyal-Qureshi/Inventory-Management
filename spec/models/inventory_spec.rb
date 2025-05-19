require 'rails_helper'

RSpec.describe Inventory, type: :model do
  describe 'scopes' do
    let!(:on_shelf_inventory) { create(:inventory, status: :on_shelf) }
    let!(:returned_inventory) { create(:inventory, status: :returned) }
    let!(:shipped_inventory) { create(:inventory, status: :shipped) }

    describe '.on_shelf' do
      it 'returns inventories with status on_shelf' do
        expect(Inventory.on_shelf).to include(on_shelf_inventory)
        expect(Inventory.on_shelf).not_to include(returned_inventory, shipped_inventory)
      end
    end

    describe '.returned' do
      it 'returns inventories with status returned' do
        expect(Inventory.returned).to include(returned_inventory)
        expect(Inventory.returned).not_to include(on_shelf_inventory, shipped_inventory)
      end
    end

    describe '.shipped' do
      it 'returns inventories with status shipped' do
        expect(Inventory.shipped).to include(shipped_inventory)
        expect(Inventory.shipped).not_to include(on_shelf_inventory, returned_inventory)
      end
    end

    describe '.returned_by_product' do
      let(:product_1) { create(:product) }
      let(:product_2) { create(:product) }
      let!(:returned_1) { create(:inventory, status: :returned, product: product_1) }
      let!(:returned_2) { create(:inventory, status: :returned, product: product_2) }
      let!(:returned_3) { create(:inventory, status: :returned, product: product_1) }

      it 'returns only returned inventories for the given product' do
        result = Inventory.returned_by_product(product_1.id)
        expect(result).to include(returned_1, returned_3)
        expect(result).not_to include(returned_2)
      end
    end
  end

  describe '.returned_products' do
    let(:product_a) { create(:product, name: 'Alpha') }
    let(:product_b) { create(:product, name: 'Beta') }
    let(:order) { create(:order) }
    let!(:returned_1) { create(:inventory, status: :returned, product: product_a, order:) }
    let!(:returned_2) { create(:inventory, status: :returned, product: product_b, order:) }
    let!(:returned_3) { create(:inventory, status: :returned, product: product_a, order:) }

    it 'returns a sorted array of products and their returned counts' do
      result = Inventory.returned_products
      expect(result[0][1]).to eq(2)
      expect(result[1][1]).to eq(1)
    end
  end
end
