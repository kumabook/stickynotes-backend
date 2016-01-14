class TagsController < ApplicationController
  before_action :require_login
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
        format.html {
          redirect_to page_path(@tag),
          notice: 'Tag was successfully created.'
        }
         format.json { render :show, status: :created }
      else
        format.html { render :new }
        format.json { render json: @tag.errors,
                           status: :unprocessable_entity }
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
