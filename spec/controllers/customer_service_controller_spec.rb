# spec/controllers/customer_service_controller_spec.rb
require 'rails_helper'

RSpec.describe CustomerServiceController, type: :controller do
  describe '#index' do
    context 'when customer service employee' do
      let(:employee) { create(:employee, :customer_service) }

      it 'allows access' do
        allow(controller).to receive(:current_user).and_return(employee)
        get :index
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq('')
      end
    end

    context 'when warehouse employee' do
      let(:employee) { create(:employee, :warehouse) }

      it 'denies access' do
        allow(controller).to receive(:current_user).and_return(employee)
        get :index
        expect(response).to redirect_to('/')
        expect(flash[:alert]).to eq('Access denied')
      end
    end
  end
end
