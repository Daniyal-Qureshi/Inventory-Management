class Employee < ApplicationRecord
  validates :name, presence: true
  validates :access_code, uniqueness: true
end
