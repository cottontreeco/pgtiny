require 'test_helper'

class FreightsControllerTest < ActionController::TestCase
  setup do
    @freight = freights(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:freights)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create freight" do
    assert_difference('Freight.count') do
      post :create, freight: { remark: @freight.remark, status: @freight.status, type: @freight.type }
    end

    assert_redirected_to freight_path(assigns(:freight))
  end

  test "should show freight" do
    get :show, id: @freight
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @freight
    assert_response :success
  end

  test "should update freight" do
    put :update, id: @freight, freight: { remark: @freight.remark, status: @freight.status, type: @freight.type }
    assert_redirected_to freight_path(assigns(:freight))
  end

  test "should destroy freight" do
    assert_difference('Freight.count', -1) do
      delete :destroy, id: @freight
    end

    assert_redirected_to freights_path
  end
end
