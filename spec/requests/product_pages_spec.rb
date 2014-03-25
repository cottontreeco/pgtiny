require 'spec_helper'

describe "Product pages" do
  subject {page}

  describe "index" do
    let(:product) {FactoryGirl.create(:product)}
    before(:each) { visit products_path }
    it {should have_title('All products')}
    it {should have_content('All products')}

    describe "show product link" do
      it {should have_link(product.name, href: product_path(product))}
    end

    describe "pagination" do
      before(:all) {40.times {FactoryGirl.create(:product)}}
      after(:all) {Product.delete_all}
      it {should have_selector('div.pagination')}
      it "should list each product" do
        Product.paginate(page: 1).each do |product|
          expect(page).to have_selector('li', text: product.name)
        end
      end
    end

    describe "delete links" do
      it {should_not have_link('delete')}
      describe "as an admin user" do
        let(:admin) {FactoryGirl.create(:admin)}
        before do
          valid_signin admin
          visit products_path
        end
        it {should have_link('delete', href: product_path(Product.first))}
        it "should be able to delete a product" do
          expect do
            click_link('delete', match: :first)
          end.to change(Product, :count).by(-1)
        end
      end
    end
  end

  describe "detail page" do
    let(:product) {FactoryGirl.create(:product)}
    let(:user1) { FactoryGirl.create(:user)}
    let(:user2) { FactoryGirl.create(:user)}
    let(:m1) {FactoryGirl.create(:review, user: user1, product: product, remark: "Foo")}
    let(:m2) {FactoryGirl.create(:review, user: user2, product: product, remark: "Bar")}
    before {visit product_path(product)}

    it {should have_content(product.name)}
    it {should have_title(product.name)}

    describe "reviews" do
      it {should have_content(user1.name)}
      it {should have_content(m1.remark)}
      it {should have_link(user_path(user2))}
      it {should have_content(m2.remark)}
      it {should have_content(product.reviews.count)}
    end
  end
end