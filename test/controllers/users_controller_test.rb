require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Sorcery::TestHelpers::Rails::Controller

  test "admin should get index" do
    @admin = users(:admin)
    login_user(@admin, login_url)
    get :index
    assert_response :success
  end

  test "member should redirect to index" do
    @member = users(:one)
    login_user(@member, login_url)
    get :index
    assert_response :redirect
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, params: {
             user: {
               email:                 'test@test.com',
               password:              'password',
               password_confirmation: 'password',
             }
           }
    end
  end

  test "should show user" do
    @member = users(:one)
    login_user(@member, login_url)
    get :show, params: { id: users(:one).id }
    assert_response :success
  end

  test "should get edit" do
    @member = users(:one)
    login_user(@member, login_url)
    get :edit, params: { id: users(:one).id }
    assert_response :success
  end

  test "should update user" do
    @member = users(:one)
    login_user(@member, login_url)
    patch :update, params: {
            id: users(:one).id,
            user: {
              email: "new@example.com"
            }
          }
    assert_redirected_to user_url(users(:one))
  end

  test "should destroy user" do
    @member = users(:one)
    login_user(@member, login_url)
    assert_difference('User.count', -1) do
      delete :destroy, params: { id: users(:one).id }
    end

    assert_redirected_to users_url
  end

end
