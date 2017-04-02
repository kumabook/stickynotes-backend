require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  include Sorcery::TestHelpers::Rails::Controller

  setup do
    @user = users(:one)
    @page = pages(:one)
    login_user(@user, login_url)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @page.id }
    assert_response :success
  end

  test "should update" do
    post :update, params: {
          id: @page.id,
          page: {
            title: "changed"
          }
         }
    assert_redirected_to page_url(@page)
  end
end
