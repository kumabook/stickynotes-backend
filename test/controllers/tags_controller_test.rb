require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  include Sorcery::TestHelpers::Rails::Controller

  setup do
    @user = users(:one)
    login_user(@user, login_url)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end
