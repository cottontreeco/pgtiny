require 'spec_helper'

describe "Review pages" do
  subject {page}
  let(:user) {FactoryGirl.create(:user)}
  let!(:product) {FactoryGirl.create(:product)}
  before (:each) do
    visit product_path(product)
  end

  describe "review listing" do
    describe "as a guest user" do
      it {should_not have_submit_button('Post')}
    end

    describe "pagination" do
      before(:all) {36.times {FactoryGirl.create(:review, product: product)}}
      after(:all) do
        Review.delete_all
        User.delete_all
        Product.delete_all
      end
      before {visit product_path(product)}
      it {should have_selector('div.pagination')}
      it "should list each review" do
        Review.paginate(page: 1).each do |review|
          expect(page).to have_selector('li', text: review.remark)
        end
      end
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

    describe "as a different user" do
      let(:diff_user) {FactoryGirl.create(:user)}
      before do
        valid_signin diff_user
        visit product_path(product)
      end
      it {should_not have_link('delete')}
    end
  end
end
