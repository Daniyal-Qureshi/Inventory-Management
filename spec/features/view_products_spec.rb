require 'rails_helper'

RSpec.feature 'View products' do
  scenario 'successfully' do
    create(:product, name: '4x6 Picture Frame', price: build(:amount, :small))
    create(:product, name: '5x7 Picture Frame', price: build(:amount, :medium))
    create(:product, name: '8x10 Picture Frame', price: build(:amount, :large))

    visit root_path

    small_frame_on_page = ProductOnPage.new('4x6 Picture Frame')
    medium_frame_on_page = ProductOnPage.new('5x7 Picture Frame')
    large_frame_on_page = ProductOnPage.new('8x10 Picture Frame')

    expect(small_frame_on_page).to have_display_name
    expect(small_frame_on_page).to be_priced_at(build(:amount, :small))

    expect(medium_frame_on_page).to have_display_name
    expect(medium_frame_on_page).to be_priced_at(build(:amount, :medium))

    expect(large_frame_on_page).to have_display_name
    expect(large_frame_on_page).to be_priced_at(build(:amount, :large))
  end

  def display_product(name)
    have_css('.product__header', text: name)
  end
end
