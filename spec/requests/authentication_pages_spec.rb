require 'spec_helper'

describe "Authentication" do
  subject { page }
  describe "signin page" do
    before { visit signin_path }
    it {should have_content('Sign in')}
    it {should have_title('Sign in')}
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid info" do
      before {click_button 'Sign in'}
      it {should have_title('Sign in')}
      it {should have_error_message('Invalid')}

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_error_message('Invalid') }
      end
    end

    describe "with valid info" do
      let(:user) {FactoryGirl.create(:user)}
      before { valid_signin(user) }

      it {should have_title(user.name)}
      it {should have_link('Users', href: users_path)}
      it {should have_link('Profile', href: user_path(user))}
      it {should have_link('Settings', href: edit_user_path(user))}
      it {should have_link('Sign out', href: signout_path)}
      it {should_not have_link('Sign in', href: signin_path)}

      describe "followed by signout" do
        before { click_link "Sign out"}
        it {should have_link('Sign in')}
      end
    end
  end

  describe "authorization" do
    describe "for non-signed-in users" do
      let(:user) {FactoryGirl.create(:user)}

      describe "when visiting home page" do
        before {visit root_path}
        it {should_not have_link('Users', href: users_path)}
        it {should_not have_link('Profile', href: user_path(user))}
        it {should_not have_link('Settings', href: edit_user_path(user))}
        it {should_not have_link('Sign out', href: signout_path)}
      end

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email.upcase
          fill_in "Password", with: user.password
          click_button "Sign in"
        end
        describe "after signing in" do
          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end

          describe "when signing in again" do
            before do
              click_link "Sign out"
              valid_signin user
            end

            it "should render the default (profile) page" do
              expect(page).to have_title(user.name)
            end
          end
        end
      end

      describe "in the Reviews controller" do
        describe "submitting to the create action" do
          before {post reviews_path}
          specify {expect(response).to redirect_to(signin_path)}
        end
        describe "submitting to the destroy action" do
          before {delete review_path(FactoryGirl.create(:review))}
          specify {expect(response).to redirect_to(signin_path)}
        end
      end

      describe "in the Users controller" do
        describe "visiting the edit page" do
          before {visit edit_user_path(user)}
          it {should have_title('Sign in')}
        end
        describe "submitting to the update action" do
          before {patch user_path(user)}
          specify {expect(response).to redirect_to(signin_path)}
        end
        describe "visiting the user index" do
          before {visit users_path}
          it {should have_title('Sign in')}
        end
        describe "visiting the following page" do
          before {visit following_user_path(user)}
          it {should have_title('Sign in')}
        end
        describe "visiting the followers page" do
          before {visit followers_user_path(user)}
          it {should have_title('Sign in')}
        end
      end

      describe "when attempting to visit new product page" do
        before { visit new_product_path }
        it {should have_title('Sign in')}
      end

      describe "when attempting to visit edit product page" do
        let(:product) {FactoryGirl.create(:product)}
        before { visit edit_product_path(product) }
        it {should have_title('Sign in')}
      end

      describe "submitting a POST request to the Product#create action" do
        let (:params) do
          {product: {name: 'Test Product'}}
        end
        before {post products_path, params}
        specify {expect(response).to redirect_to(signin_path)}
      end

      describe "submitting a PATCH request to the Product#update action" do
        let(:new_product) {FactoryGirl.create(:product)}
        before {patch product_path(new_product)}
        specify {expect(response).to redirect_to(signin_path)}
      end
    end

    describe "as wrong user" do
      let(:user) {FactoryGirl.create(:user)}
      let(:wrong_user) {FactoryGirl.create(:user, email: "wrong@example.com")}
      before {valid_signin(user, no_capybara: true)}

      describe "submitting a GET request to the Users#edit action" do
        before {get edit_user_path(wrong_user)}
        specify {expect(response.body).not_to match(full_title('Edit user'))}
        specify {expect(response).to redirect_to(root_url)}
      end

      describe "submitting a PATCH request to the Uers#update action" do
        before {patch user_path(wrong_user)}
        specify {expect(response).to redirect_to(root_url)}
      end
    end

    describe "as normal user" do
      let(:user) {FactoryGirl.create(:user)}
      before {valid_signin(user, no_capybara: true)}

      describe "submitting a GET request to the Users#new action" do
        before {get new_user_path}
        specify {expect(response.body).not_to match(full_title('Edit user'))}
        specify {expect(response).to redirect_to(root_url)}
      end

      describe "submitting a POST request to the Users#create action" do
        let (:params) do
          {user: {name: user.name, email: user.email,
                  password: user.password,
                  password_confirmation: user.password}}
        end
        before {post users_path, params}
        specify {expect(response).to redirect_to(root_url)}
      end
    end

    describe "as non-admin user" do
      let(:user) {FactoryGirl.create(:user)}
      let(:non_admin){FactoryGirl.create(:user)}
      before {valid_signin non_admin, no_capybara: true}
      describe "submitting a DELETE request to the Users#destroy action" do
        before {delete user_path(user)}
        specify {expect(response).to redirect_to(root_url)}
      end
    end

    describe "as admin user" do
      let(:admin) {FactoryGirl.create(:admin)}
      before {valid_signin admin, no_capybara: true}
      describe "submitting a DELETE request to the Users#destroy action to self destroy" do
        before {delete user_path(admin)}
        specify {expect(response).to redirect_to(root_url)}
      end
    end
  end
end
