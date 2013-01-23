require 'spec_helper'

describe "MicropostPages" do
  subject {page}
  let(:user) {FactoryGirl.create(:user)}
  before {sign_in user}

  describe "micropost creation" do
    before {visit cache_path}

    describe "with invalid information" do
      it "should not create a micropost" do
        expect {click_button "Post"}.not_to change(Micropost, :count)
            # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
            # get micropost_pages_index_path
            # response.status.should be(200)
      end

      describe "error messages" do
        before {click_button "Post"}
        it {should have_content('error')}
      end
    end

    describe "with valid information" do
      before {fill_in 'micropost_content', with: "Lorem ipsum"}
      it "should create a micropost" do
        expect {click_button "poast"}.to change(Micropost, :count).by(1)
      end
    end
  end
end
