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
end
