class Api::V1::TagsController < Api::V1::ApiController
  before_action :doorkeeper_authorize!
  respond_to    :json

  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  def show
  end

  def index
    @tags = Tag.where(user: current_user)
  end

  def create
    @tag = Tag.new(tag_params)
    @tag.user = current_user

    respond_to do |format|
      if @tag.save
        render :show, status: :created
      else
        render json: @tag.errors,
               status: :unprocessable_entity
      end
    end
  end

  def new
    @tag = Tag.new
  end

  def destory
  end

  def update
  end

  private
  def tag_params
    params.require(:tag).permit(:name)
  end

  def set_tag
    @tag  = Tag.includes(:user).find_by(id: params[:id])
    if @tag.nil?
      render_not_found
    end
  end
end
