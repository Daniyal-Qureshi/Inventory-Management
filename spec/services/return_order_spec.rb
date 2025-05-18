require 'rails_helper'

RSpec.describe ReturnOrder do
  let(:employee) { create(:employee) }
  let(:product) { create(:product) }
  let(:order) { create(:order) }
  let!(:inventory1) { create(:inventory, product: product, status: :shipped, order: order) }
  let!(:inventory2) { create(:inventory, product: product, status: :shipped, order: order) }
  
  describe '.run' do
    it 'marks inventory as returned' do
      ReturnOrder.run(employee, order)
      
      expect(inventory1.reload.status).to eq('returned')
      expect(inventory2.reload.status).to eq('returned')
    end
    
    it 'creates inventory status changes' do
      expect {
        ReturnOrder.run(employee, order)
      }.to change(InventoryStatusChange, :count).by(2)
      
      status_changes = InventoryStatusChange.last(2)
      status_changes.each do |status_change|
        expect(status_change.status_from).to eq('shipped')
        expect(status_change.status_to).to eq('returned')
        expect(status_change.actor).to eq(employee)
      end
    end
    
    it 'updates the product on_shelf counter' do
      product.update_on_shelf_counter
      expect(product.reload.on_shelf).to eq(0)
      
      ReturnOrder.run(employee, order)
      
      # Returned items don't count as on_shelf
      expect(product.reload.on_shelf).to eq(0)
    end
    
    it 'returns true when successful' do
      result = ReturnOrder.run(employee, order)
      expect(result).to be true
    end
  end
end 