require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:role) }
    it { should validate_uniqueness_of(:access_code) }
  end

  describe 'enums' do
    it { should define_enum_for(:role).with_values(warehouse: 0, customer_service: 1) }
  end

  describe 'role methods' do
    it 'identifies warehouse employees' do
      warehouse_employee = create(:employee, role: :warehouse)
      customer_service_employee = create(:employee, role: :customer_service)

      expect(warehouse_employee.warehouse?).to be true
      expect(warehouse_employee.customer_service?).to be false

      expect(customer_service_employee.warehouse?).to be false
      expect(customer_service_employee.customer_service?).to be true
    end
  end
end
