class DevSeed
  PRICINGS = {
    '3x5' => Money.new(499, 'USD'),
    '4x6' => Money.new(999, 'USD'),
    '5x7' => Money.new(1899, 'USD'),
    '8x10' => Money.new(2899, 'USD')
  }.freeze

  COLORS = %w[Gold Silver Bronze].freeze

  def self.run
    PRICINGS.each do |size, price|
      COLORS.each do |color|
        Product.create!(name: "#{color} #{size} Picture Frame", price: price)
      end
    end
  end
end
