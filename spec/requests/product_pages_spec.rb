require 'spec_helper'

describe "Product pages" do
  subject {page}

  describe "index" do
    # use let! because show product link test
    # is the first time product is mentioned
    let!(:product) {FactoryGirl.create(:product)}
    before(:each) { visit products_path }
    it {should have_title('Products')}
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

    describe "edit and delete links" do
      it {should_not have_link('delete')}
      describe "as an admin user" do
        let(:admin) {FactoryGirl.create(:admin)}
        before do
          valid_signin admin # sign in directs to profile afterwards
          visit products_path # need to visit again
        end
        it {should have_link('Edit', href: edit_product_path(Product.first))}
        it {should have_link('Delete', href: product_path(Product.first))}
        it "should be able to delete a product" do
          expect do
            click_link('Delete', match: :first)
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
      it {should have_link(m2.user.name, href: user_path(m2.user))}
      it {should have_css("img[src*='missing-avatar.png']")}
      it {should have_content(m2.remark)}
      it {should have_content(product.reviews.count)}
    end
  end

  describe "new product" do
    let (:user) { FactoryGirl.create(:user)}
    let(:create) {"Create product"}
    before(:each) do
      valid_signin user
      visit new_product_path
    end

    it { should have_content('New Product') }
    it { should have_title(full_title('New Product')) }

    describe "with invalid information" do
      it "should not create a user" do
        expect {click_button create}.not_to change(Product, :count)
      end
    end
    describe "with valid information" do
      before {fill_in "Name", with: "Example Product"}
      it "should create a product" do
        expect {click_button create}.to change(Product, :count).by(1)
      end
    end

    describe "with repeated name" do
      let!(:product) {FactoryGirl.create(:product, name: "Product 1")}
      before {fill_in "Name", with: "Product 1"}
      it "should not create a product" do
        expect {click_button create}.not_to change(Product, :count)
      end
    end
  end

  describe "edit" do
    let (:admin) { FactoryGirl.create(:admin)}
    let(:product) {FactoryGirl.create(:product)}
    before do
      valid_signin admin
      visit edit_product_path(product)
    end

    describe "page" do
      it {should have_content("Edit the product")}
      it {should have_title("Edit Product")}
    end

    describe "with invalid information" do
        before do
          fill_in "Name", with: " "
          click_button "Save changes"
        end
      it {should have_content('error')}
    end

    describe "with valid information" do
      let(:new_name) {"New Name"}
      before do
        fill_in "Name", with: new_name
        click_button "Save changes"
      end
      it {should have_title(new_name)}
      it {should have_selector('div.alert.alert-success')}
      specify {expect(product.reload.name).to eq new_name}
    end

    describe "as a non-admin user" do
      let(:user) {FactoryGirl.create(:user)}
      let(:new_name) {"Wrong Name"}
      let(:params) do
        {product: {name: new_name}}
      end
      before { valid_signin user, no_capybara: true }

      describe "submitting a PATCH request to the Product#update action" do
        before { patch product_path(product), params }
        specify {expect(product.reload.name).not_to eq new_name}
      end

      describe "submitting a DELETE request to the Users#destroy action" do
        before {delete user_path(user)}
        specify {expect(response).to redirect_to(root_url)}
      end
    end
  end

end
