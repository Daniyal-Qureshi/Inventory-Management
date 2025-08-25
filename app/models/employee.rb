class Employee < ApplicationRecord
  enum role: { warehouse: 0, customer_service: 1 }

  validates :name, presence: true
  validates :access_code, uniqueness: true
  validates :role, presence: true
end
