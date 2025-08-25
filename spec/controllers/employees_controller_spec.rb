require 'rails_helper'

RSpec.describe EmployeesController do
  context 'GET index' do
    it 'disallows access when not signed in' do
      get :index
      expect(response).to redirect_to(sign_in_path)
    end

    it 'allows access when signed in' do
      employee = create(:employee)
      get :index, params: {}, session: { employee_id: employee.id }
      expect(response).not_to redirect_to(sign_in_path)
    end
  end

  describe '#index' do
    context 'when warehouse employee' do
      let(:employee) { create(:employee, :warehouse) }

      it 'allows access' do
        allow(controller).to receive(:current_user).and_return(employee)
        get :index
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq('')
      end
    end

    context 'when customer service employee' do
      let(:employee) { create(:employee, :customer_service) }

      it 'denies access' do
        allow(controller).to receive(:current_user).and_return(employee)
        get :index
        expect(response).to redirect_to('/')
        expect(flash[:alert]).to eq('Access denied')
      end
    end
  end
end
