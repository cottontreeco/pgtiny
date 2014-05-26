require 'spec_helper'

describe User do
  before do @user = User.new(
      name: "Example User",
      email: "user@example.com",
      password: "foobar",
      password_confirmation: "foobar")
  end

  subject {@user}
  it {should respond_to(:name)}
  it {should respond_to(:email)}
  it {should respond_to(:password_digest)}
  it {should respond_to(:password)}
  it {should respond_to(:password_confirmation)}
  it {should respond_to(:remember_token)}
  it {should respond_to(:authenticate)}
  it {should respond_to(:admin)}
  it {should respond_to(:reviews)}
  it {should respond_to(:product_feed)}
  it {should respond_to(:relationships)}
  it {should respond_to(:followed_users)}

  it {should be_valid}
  it {should_not be_admin}

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end
    it {should be_admin}
  end
  describe "when password is not present" do
    before do
      @user = User.new(
          name: "Example User",
          email: "user@example.com",
          password: " ",
          password_confirmation: " ")
    end
    it {should_not be_valid}
  end

  describe "when password doesn't match confirmation" do
    before {@user.password_confirmation="mismatch"}
    it {should_not be_valid}
  end

  describe "when name is not present" do
    before {@user.name="  "}
    it {should_not be_valid}
  end

  describe "when email is not present" do
    before {@user.email = "  "}
    it {should_not be_valid}
  end

  describe "when name is too long" do
    before {@user.name="a"*51}
    it {should_not be_valid}
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com foob@barz..net]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it {should_not be_valid}
  end

  describe "with a mixed case email address" do
    let(:mixed_case_email) {"Foo@ExAmPLe.COm"}
    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "with a password that's too short" do
    before {@user.password = @user.password_confirmation = "a"*5}
    it {should be_invalid}
  end

  describe "return value of authenticate method" do
    before {@user.save}
    let(:found_user) {User.find_by(email: @user.email)}

    describe "with valid password" do
      it {should eq found_user.authenticate(@user.password)}
    end

    describe "with invalid password" do
      let (:user_for_invalid_password) { found_user.authenticate("invalid")}
      it {should_not eq user_for_invalid_password}
      specify { expect(user_for_invalid_password).to be_false}
    end

    describe "remember token" do
      before {@user.save}
      its(:remember_token) {should_not be_blank}
      it {expect(@user.remember_token).not_to be_blank}
    end
  end

  describe "review associations" do
    before {@user.save}
    let!(:older_review) do
      FactoryGirl.create(:review, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_review) do
      FactoryGirl.create(:review, user: @user, created_at: 1.hour.ago)
    end
    it "should have the right reviews in the right order" do
      expect(@user.reviews.to_a).to eq [newer_review, older_review]
    end

    it "should destroy associated reviews" do
      reviews = @user.reviews.to_a #must call to_a to create a copy
      @user.destroy #otherwise destroy will make reviews array empty
      expect(reviews).not_to be_empty
      reviews.each do |review|
        expect(Review.where(id: review.id)).to be_empty
      end
      # if using find, it will raise error, where will return empty object
      #expect do
      #  Review.find(review)
      #end.to raise_error(ActiveRecord::RecordNotFound)
    end

    describe "status" do
      let(:unfollowed_review) do
        FactoryGirl.create(:review, user: FactoryGirl.create(:user))
      end
      its(:product_feed) {should include(newer_review)}
      its(:product_feed) {should include(older_review)}
      its(:product_feed) {should_not include(unfollowed_review)}
    end
  end
end