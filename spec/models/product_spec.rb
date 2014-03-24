require 'spec_helper'

describe Product do
    before do @product =
        Product.new(name: "Test product")
    end

    subject {@product}
    it {should respond_to(:name)}
    it {should respond_to(:reviews)}
    it {should be_valid}

    describe "when name is not present" do
      before {@product.name="  "}
      it {should_not be_valid}
    end

    describe "when name is too long" do
      before {@product.name="a"*65}
      it {should_not be_valid}
    end

    describe "when name is already taken" do
      before do
        product_with_same_name = @product.dup
        product_with_same_name.name = @product.name.upcase
        product_with_same_name.save
      end
      it {should_not be_valid}
    end

    describe "review associations" do
      before {@product.save}
      let!(:older_review) do
        FactoryGirl.create(:review, product: @product, created_at: 1.day.ago)
      end
      let!(:newer_review) do
        FactoryGirl.create(:review, product: @product, created_at: 1.hour.ago)
      end
      it "should have the right reviews in the right order" do
        expect(@product.reviews.to_a).to eq [newer_review, older_review]
      end

      it "should destroy associated reviews" do
        reviews = @product.reviews.to_a #must call to_a to create a copy
        @product.destroy #otherwise destroy will make reviews array empty
        expect(reviews).not_to be_empty
        reviews.each do |review|
          # expect(Review.where(id: review.id)).to be_empty
          # if using find, it will raise error, where will return empty object
          expect do
            Review.find(review)
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
end
