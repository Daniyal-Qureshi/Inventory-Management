RSpec.describe ReceiveProduct do
  let(:product) { create(:product) }
  let(:employee) { create(:employee) }
  let(:quantity) { 2 }

  it "updates on_shelf counter after receiving" do
    expect {
      ReceiveProduct.run(employee, product, quantity)
    }.to change { product.reload.on_shelf }.by(quantity)
  end
end
