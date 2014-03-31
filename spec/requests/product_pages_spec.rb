require 'spec_helper'

describe "Product pages" do
  subject {page}

  describe "index" do
    # use let! because show product link test
    # is the first time product is mentioned
    let!(:product) {FactoryGirl.create(:product)}
    before(:each) { visit products_path }
    it {should have_title('All products')}
    it {should have_content('All products')}

    describe "show product link" do
      it {should have_link(product.name, href: product_path(product))}
    end

    describe "pagination" do
      before(:all) {30.times {FactoryGirl.create(:product)}}
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
          valid_signin admin # sign in directs to profile afterwards
          visit products_path # need to visit again
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

  describe "detail" do
    let!(:product) {FactoryGirl.create(:product)}
    let!(:m1) {FactoryGirl.create(:review, product: product, remark: "Foo")}
    let!(:m2) {FactoryGirl.create(:review, product: product, remark: "Bar")}
    before(:each) {visit product_path(product)}

    it {should have_content(product.name)}
    it {should have_title(product.name)}

    describe "reviews" do
      it {should have_content(m1.remark)}
      it {should have_link(m2.user.name,
                           href: user_path(m2.user))}
      it {should have_content(m2.remark)}
      it {should have_content(product.reviews.count)}
    end
  end

  describe "new product" do
    before {visit new_product_path}
    let(:create) {"Create product"}

    it { should have_content('New Product') }
    it { should have_title(full_title('New Product')) }
  end
end