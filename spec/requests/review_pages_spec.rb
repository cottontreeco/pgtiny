require 'spec_helper'

describe "Review pages" do
  subject {page}
  let(:user) {FactoryGirl.create(:user)}
  let!(:product) {FactoryGirl.create(:product)}

  describe "review listing" do
    before {visit product_path(product)}
    describe "as a guest user" do
      it {should_not have_submit_button('Post')}
    end

    describe "as a reviewer" do
      let!(:review) {FactoryGirl.create(:review, product: product, user: user, score: 5)}
        before do
          valid_signin user
          visit product_path(product)
        end
      it {should have_link('edit', href: edit_review_path(review))}
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

    describe "ratings" do
      let!(:review1) {FactoryGirl.create(:review, product: product, score: 2)}
      let!(:review2) {FactoryGirl.create(:review, product: product, score: 5)}
      before { visit product_path(product) }
      it {should have_content('Rating: 2')}
      it {should have_content('Rating: 5')}
      it {should have_content('Average rating: 3.5')}
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
      before do
        fill_in 'review_remark', with: "Lorem ipsum"
        select '3', from: 'review_score'
      end
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

  describe "edit review" do
    let!(:review) {FactoryGirl.create(:review, product: product, user: user, score: 5)}

    describe "page" do
      before(:each) do
        valid_signin user
        visit edit_review_path(review)
      end

      it {should have_content("Update your review")}
      it {should have_title("Edit review")}

      describe "with invalid information" do
        before do
          select 0, from: "Score"
          click_button "Save changes"
        end
        it {should have_content('error')}
      end

      describe "with valid information" do
        let(:new_remark) {"New remark"}
        let(:new_score) {1}
        before do
          fill_in "Remark", with: new_remark
          select new_score, from: "Score"
          click_button "Save changes"
        end

        it {should have_content(new_remark)}
        it {should have_selector('div.alert.alert-success')}

        specify {expect(review.reload.remark).to eq new_remark}
        specify {expect(review.reload.score).to eq new_score}
      end
      
      describe "click delete button" do
        it "should delete a review" do
          expect {click_button "Delete"}.to change(Review, :count).by(-1)
        end
      end
    end

    describe "as a different user" do
      let(:diff_user) {FactoryGirl.create(:user)}
      before do
        valid_signin diff_user
        visit product_path(product)
      end
      it {should_not have_link('edit')}
    end
  end
end
