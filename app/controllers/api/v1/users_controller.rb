class Api::V1::UsersController < Api::V1::ApiController
  respond_to :json

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.type = User::MEMBER
    respond_to do |format|
      if @user.save
        format.json { render :show, json: @user }
      else
        p @user.errors
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end
