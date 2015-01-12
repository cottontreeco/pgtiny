require 'spec_helper'

describe Review do
  let(:user) {FactoryGirl.create(:user)}
  let(:product) {FactoryGirl.create(:product)}
  #before {@review = Review.new(remark: "Lorem ipsum",
  #    user_id: user.id,
  #    product_id: product.id)}
  before {@review = user.reviews.build(
      remark: "Lorem ipsum",
      product_id: product.id,
      score: 3)}

  subject {@review}

  it {should respond_to(:score)}
  it {should respond_to(:remark)}
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

  describe "with zero score" do
    before {@review.score=0}
    it {should_not be_valid}
  end

  describe "with out of range score" do
    before {@review.score=6}
    it {should_not be_valid}
  end

  describe "with blank remark" do
    before {@review.remark = " "}
    it {should_not be_valid}
  end

  describe "with remark that is too long" do
    before {@review.remark = "a"*141}
    it {should_not be_valid}
  end
end
