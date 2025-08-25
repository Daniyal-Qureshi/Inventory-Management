require 'rails_helper'

RSpec.feature 'Employee signs in' do
  scenario 'unsuccessfully at first' do
    create(:employee, name: 'Jane Doe', access_code: '41315')

    visit root_path
    click_on sign_in
    attempt_code('41')

    expect(page).not_to display_employee_portal

    attempt_code('41315')

    expect(page).to display_employee_portal
    expect(page).to welcome_employee('Jane Doe')
  end

  scenario 'and then signs out' do
    create(:employee, name: 'Jane Doe', access_code: '41315')

    visit root_path
    click_on sign_in
    attempt_code('41315')

    expect(page).to display_employee_portal

    click_on sign_out

    expect(current_path).to eq(root_path)
    visit employees_path
    expect(current_path).to eq(sign_in_path)
  end

  def sign_in
    I18n.t('layouts.application.sign_in')
  end

  def sign_out
    I18n.t('layouts.application.sign_out')
  end

  def attempt_code(code)
    fill_in I18n.t('helpers.label.session.access_code'), with: code
    click_on I18n.t('helpers.submit.session.submit')
  end

  def display_employee_portal
    have_css('.employees__header', text: I18n.t('employees.index.title'))
  end

  def welcome_employee(name)
    have_css('.employees__welcome', text: I18n.t('employees.index.welcome', name:))
  end
end
