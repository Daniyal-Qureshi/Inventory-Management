require 'rails_helper'

RSpec.describe RestocksController, type: :controller do
  let(:employee) { create(:employee, :warehouse) }
  let(:product) { create(:product) }

  before do
    allow(controller).to receive(:current_user).and_return(employee)
  end

  describe 'POST #create' do
    context 'when restock is successful' do
      let!(:returned_inventory) { create(:inventory, product:, status: :returned) }

      it 'calls the service and redirects with notice' do
        expect(RestockReturnedProduct).to receive(:run).with(employee, product).and_call_original

        post :create, params: { product_id: product.id }

        expect(response).to redirect_to(employees_path)
        expect(flash[:notice]).to eq('Returned products have been restocked')
      end
    end

    context 'when no returned inventories exist' do
      it 'still redirects (gracefully handles no-op)' do
        expect(RestockReturnedProduct).to receive(:run).with(employee, product).and_call_original

        post :create, params: { product_id: product.id }

        expect(response).to redirect_to(employees_path)
        expect(flash[:notice]).to eq('Returned products have been restocked')
      end
    end
  end
end
