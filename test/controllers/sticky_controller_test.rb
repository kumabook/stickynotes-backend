require 'test_helper'

class StickyControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get destory" do
    get :destory
    assert_response :success
  end

  test "should get update" do
    get :update
    assert_response :success
  end

end
