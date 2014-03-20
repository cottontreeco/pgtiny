require 'spec_helper'

describe Review do
  let(:user) {FactoryGirl.create(:user)}
  let(:product) {FactoryGirl.create(:product)}
  before {@review = Review.new(content: "Lorem ipsum",
      user_id: user.id,
      product_id: product.id)}

  subject {@review}

  it {should respond_to(:content)}
  it {should respond_to(:user_id)}
  it {should respond_to(:user)}
  its(:user){should eq user}

  it {should respond_to(:product_id)}
  it {should respond_to(:product)}
  its(:product){should eq product}

  it {should be_valid}
  
  describe "when user_id is not present" do
    before {@review.user_id=nil}
    it {should_not be_valid}
  end

  describe "when product_id is not present" do
    before {@review.product_id=nil}
    it {should_not be_valid}
  end
end
