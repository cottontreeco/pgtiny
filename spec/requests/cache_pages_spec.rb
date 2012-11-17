require 'spec_helper'

describe "Static Pages" do
  subject { page }

  describe "Home page" do
    before {visit '/'}
    describe "should have the content 'Your Cache'" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      #visit '/'
      #page.should have_content('Your Cache')
      it { should have_link('Sign in', href: signin_path) }
    end
  end
end
