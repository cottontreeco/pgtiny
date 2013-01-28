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
        #visit cache_url
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          # the first '#' is Capybara syntax
          # the second '#' is ruby string interpolation
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end
    end
  end
end
