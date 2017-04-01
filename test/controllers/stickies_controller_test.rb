require 'test_helper'

class StickiesControllerTest < ActionController::TestCase
  include Sorcery::TestHelpers::Rails::Controller

  setup do
    @user = users(:one)
    @sticky = stickies(:one)
    login_user(@user, login_url)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sticky" do
    assert_difference('Sticky.count') do
      post :create, params: {
             sticky: {
               width:    100,
               height:   100,
               left:     100,
               top:      100,
               content: 'created_content',
               color:   'blue',
               page_id:  1,
               user_id:  1,
               state:    'normal',
               tags:     ['tag1']
             }
           }
    end

    assert_redirected_to sticky_url(Sticky.first)
  end

  test "should show sticky" do
    get :show, params: { id: @sticky.id }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @sticky.id }
    assert_response :success
  end

  test "should update sticky" do
    patch :update, params: {
            id: @sticky.id,
            sticky: {
              title: "new_title"
            }
          }
    assert_redirected_to sticky_url(@sticky)
  end

  test "should destroy sticky" do
    assert_difference('Sticky.where(state: :normal).count', -1) do
      delete :destroy, params: { id: @sticky.id }
    end

    assert_redirected_to stickies_url
  end

end
