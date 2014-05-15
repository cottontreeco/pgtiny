require 'spec_helper'

describe "Review pages" do
  subject {page}
  let(:user) {FactoryGirl.create(:user)}
  let!(:product) {FactoryGirl.create(:product)}
  before (:each) do
    visit product_path(product)
  end

  describe "review lising" do
    describe "as a guest user" do
      it {should_not have_submit_button('Post')}
    end
  end

  describe "review creation" do
    before(:each) do
      valid_signin user
      visit product_path(product)
    end

    describe "with invalid information" do
      it "should not create a review" do
        expect {click_button "Post"}.not_to change(Review, :count)
      end

      describe "error messages" do
        before {click_button "Post"}
        it {should have_content('error')}
      end
    end

    describe "with valid information" do
      before {fill_in 'review_remark', with: "Lorem ipsum"}
      it "should create a review" do
        expect {click_button "Post"}.to change(Review, :count).by(1)
      end
    end

    describe "when already have a review" do
      before do
        FactoryGirl.create(:review, product: product, user: user, remark: "Foo")
        valid_signin user
        visit product_path(product)
      end
      it {should_not have_submit_button('Post')}
    end
  end

  describe "review destruction" do
    before {FactoryGirl.create(:review, product: product, user: user)}
    describe "as correct user" do
      before do
        valid_signin user
        visit product_path(product)
      end
      it "should delete a review" do
        expect {click_link "delete"}.to change(Review, :count).by(-1)
      end
    end
  end
end
