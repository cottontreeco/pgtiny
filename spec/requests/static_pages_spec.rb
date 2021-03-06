require 'spec_helper'

describe "Static pages" do
  let(:title_divider) {'|'}
  subject { page }

  #common test using variables
  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading)}
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }

    let(:heading) {'Project Tiny Web App'}
    let(:page_title) {''}
    it_should_behave_like "all static pages"
    it { should_not have_title("#{title_divider} Home") }

    #maintaining the old style before using the page subject
    it "should have the content 'Sign in'" do
      expect(page).to have_content("Sign in")
    end
    it "should have the content 'Sign up'" do
      expect(page).to have_content("Sign up")
    end

    describe "for signed-in users" do
      let(:user) {FactoryGirl.create(:user)}
      before do
        FactoryGirl.create(:review, user: user, remark: "Lorem ipsum")
        FactoryGirl.create(:review, user: user, remark: "Dolor sit amet")
        valid_signin user
        visit root_path
      end

      it "should render the user's feed" do
        user.reviewer_feed.each do |item|
          # the first # is Capybara syntax to test for CSS id
          expect(page).to have_selector("li##{item.id}", text: item.remark)
        end
      end

      describe "follower/following counts" do
        let(:other_user){FactoryGirl.create(:user)}
        before do
          other_user.follow!(user)
          visit root_path
        end
        it {should have_link("0 following", href: following_user_path(user))}
        it {should have_link("1 followers", href: followers_user_path(user))}
      end
    end
  end

  describe "About page" do
    before { visit about_path }
    let(:heading) {'About PgTiny'}
    let(:page_title) {'About'}
    it_should_behave_like "all static pages"
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading) {'Help with PgTiny'}
    let(:page_title) {'Help'}
    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "Products"
    expect(page).to have_title(full_title('Products'))
    click_link "About"
    expect(page).to have_title(full_title('About'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title("Sign Up"))
    click_link "PG Tiny"
    expect(page).to have_title(full_title(''))
  end
end
