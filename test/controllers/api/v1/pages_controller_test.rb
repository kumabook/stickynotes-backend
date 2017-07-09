require 'test_helper'

class Api::V1::PagesControllerTest < ActionDispatch::IntegrationTest
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
    post '/oauth/token.json', params: {
           grant_type:    'password',
           client_id:     @application.uid,
           client_secret: @application.secret,
           username:      @email,
           password:      @password
         }
    @token = JSON.parse @response.body
  end

  test "should get index" do
    get '/api/v1/pages',
        params: {},
        headers: {
          Authorization: "Bearer #{@token['access_token']}",
          CONTENT_TYPE:  "application/json",
          ACCEPT:        "application/json",
        }
    assert_response :success
  end
end
