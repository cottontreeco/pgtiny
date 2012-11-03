require 'test_helper'

class CacheControllerTest < ActionController::TestCase
  test "should get index page" do
    get :index
    assert_response :success
    assert_select 'navbar navbar-fixed-top navbar-inner container ul li', minimum: 4
    assert_select '#main .entry', 3
    assert_select 'h3', 'Apple iPhone 5'
  end

  test "should get about page" do
    get :about
    assert_response :success
    assert_select 'h1', 'About Social Proof'
  end

  test "should get contact page" do
    get :contact
    assert_response :success
    assert_select 'h1', 'Contacts for Social Proof'
  end
end
