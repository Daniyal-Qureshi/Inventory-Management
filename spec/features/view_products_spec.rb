require 'rails_helper'

RSpec.feature 'View products' do
  scenario 'successfully' do
    create(:product, name: '4x6 Picture Frame', price: build(:amount, :small))
    create(:product, name: '5x7 Picture Frame', price: build(:amount, :medium))
    create(:product, name: '8x10 Picture Frame', price: build(:amount, :large))

    visit root_path

    expect(page).to display_product('4x6 Picture Frame')
    expect(page).to display_product('5x7 Picture Frame')
    expect(page).to display_product('8x10 Picture Frame')
  end

  def display_product(name)
    have_css('.product__header', text: name)
  end
end
