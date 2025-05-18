require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'associations' do
    it { should belong_to(:ships_to).class_name('Address') }
    it { should have_many(:line_items).class_name('OrderLineItem') }
    it { should have_many(:inventories) }
  end
  
  describe 'scopes' do
    describe '.with_returned_items' do
      it 'returns orders with returned inventory items' do
        order_with_returned = create(:order)
        create(:inventory, order: order_with_returned, status: :returned)
        
        order_without_returned = create(:order)
        create(:inventory, order: order_without_returned, status: :shipped)
        
        unfulfilled_order = create(:order)
        
        expect(Order.with_returned_items).to include(order_with_returned)
        expect(Order.with_returned_items).not_to include(order_without_returned)
        expect(Order.with_returned_items).not_to include(unfulfilled_order)
      end
    end
    
    describe '.with_address_issues' do
      it 'returns orders with returned items and unfixed addresses' do
        order_with_issue = create(:order, address_fixed: false)
        create(:inventory, order: order_with_issue, status: :returned)
        
        order_fixed = create(:order, address_fixed: true)
        create(:inventory, order: order_fixed, status: :returned)
        
        order_no_return = create(:order, address_fixed: false)
        create(:inventory, order: order_no_return, status: :shipped)
        
        expect(Order.with_address_issues).to include(order_with_issue)
        expect(Order.with_address_issues).not_to include(order_fixed)
        expect(Order.with_address_issues).not_to include(order_no_return)
      end
    end
  end
  
  describe '#has_returned_items?' do
    it 'returns true when order has returned inventory' do
      order = create(:order)
      create(:inventory, order: order, status: :returned)
      
      expect(order.has_returned_items?).to be true
    end
    
    it 'returns false when order has no returned inventory' do
      order = create(:order)
      create(:inventory, order: order, status: :shipped)
      
      expect(order.has_returned_items?).to be false
    end
    
    it 'returns false when order has no inventory' do
      order = create(:order)
      
      expect(order.has_returned_items?).to be false
    end
  end
  
  describe '#mark_address_as_fixed!' do
    it 'sets address_fixed to true' do
      order = create(:order, address_fixed: false)
      
      order.mark_address_as_fixed!
      
      expect(order.reload.address_fixed).to be true
    end
  end
end 