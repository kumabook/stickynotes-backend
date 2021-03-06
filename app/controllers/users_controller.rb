class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, only: [:index]
  respond_to :html, :json

  # GET /users
  # GET /users.json
  def index
    @stickies_count = Sticky.count
    @active_user_count = User.where(updated_at: 1.day.ago..Time.now).count
    @users = User.order(updated_at: :desc)
                 .bonzo(params[:bonzo])
                 .includes(:oauth_access_tokens)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new.becomes(User)
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.type = User::MEMBER
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    if current_user&.admin?
      @user = User.find(params[:id]).becomes(User)
    else
      @user = current_user.becomes(User)
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
