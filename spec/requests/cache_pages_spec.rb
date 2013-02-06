require 'spec_helper'

describe "Static Pages" do
  subject { page }

  describe "Home page" do
    before {visit '/'}
    describe "should have the content 'Your Cache'" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      #visit '/'
      it { should have_selector('title', text: 'Home')}
      it { should have_link('Sign in', href: signin_path) }
    end

    describe "for signed-in users" do
      let(:user) {FactoryGirl.create(:user)}
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit '/'
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          # the first '#' is Capybara syntax
          # the second '#' is ruby string interpolation
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "should have multiple feed count" do
        it {should have_content('2 microposts')}
      end

      describe "should have singular feed count" do
        before do
          click_link "delete"
        end
        it {should_not have_content('microposts')}
        it {should have_content('1 micropost')}
      end

      describe "follower/following counts" do
        let(:other_user) {FactoryGirl.create(:user)}
        before do
          other_user.follow!(user)
          visit '/'
        end
        it {should have_link("0 following", href: following_user_path(user))}
        it {should have_link("1 followers", href: followers_user_path(user))}
      end
    end
  end
end
