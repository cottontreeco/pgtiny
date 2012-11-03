require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @input_attrib = {
        :name => "sam",
        :email => "sam@test.com",
        :password => "private",
        :password_confirmation => "private"
    }
    @user = users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get new via signup" do
    get :signup
    assert_response :success
    assert_select 'h1', 'Sign up'
    assert_select 'title', 'Sign up'
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, :user => @input_attrib
    end

    assert_redirected_to users_path
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    put :update, id: @user, user: @input_attrib
    assert_redirected_to users_path
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
