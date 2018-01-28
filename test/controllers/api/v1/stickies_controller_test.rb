require 'test_helper'

class Api::V1::StickiesControllerTest < ActionDispatch::IntegrationTest
  include Sorcery::TestHelpers::Rails::Integration
  include Sorcery::TestHelpers::Rails::Controller

  setup do
    @application = Doorkeeper::Application.create!(name: 'firefox',
                                                   redirect_uri: 'urn:ietf:wg:oauth:2.0:oob')
    @email    = 'test@test.com'
    @password = 'test_password'
    @user = User.create!(email: @email,
                         password: @password,
                         password_confirmation: @password,
                         type: Member.name)
    @page   = Page.create!(title:     'title',
                           url:       'https://example.com',
                           user_id:   @user.id,
                           visual_url: nil)
    @sticky = Sticky.create!(uuid:    SecureRandom.uuid,
                             content: 'content',
                             color:   'red',
                             width:   100,
                             height:  100,
                             left:    100,
                             top:     100,
                             page_id: @page.id,
                             user_id: @user.id,
                             state:   0)
    @tag = @sticky.tags.create!(name: "tag",
                                user_id: @user.id)
    post '/oauth/token.json', params: {
           grant_type:    'password',
           client_id:     @application.uid,
           client_secret: @application.secret,
           username:      @email,
           password:      @password
         }
    @token = JSON.parse @response.body
#    @sticky = stickies(:one)
  end

  test "should get index" do
    get '/api/v1/stickies',
        params: {},
        headers: {
          Authorization: "Bearer #{@token['access_token']}",
          CONTENT_TYPE:  "application/json",
          ACCEPT:        "application/json",
        }
    assert_response :success
  end

  test "should import stickies" do
    post '/api/v1/stickies',
         params: {},
         headers: {
           Authorization: "Bearer #{@token['access_token']}",
           CONTENT_TYPE:  "application/json",
           ACCEPT:        "application/json",
         }
    assert_response :success
  end

end
