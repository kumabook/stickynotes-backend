class StickiesController < ApplicationController
  before_action :require_login
  before_action :set_sticky, only: [:show, :edit, :update, :destroy]
  before_action :set_page, only: [:index]
  before_action :set_tag,  only: [:index]
  before_action :set_user, only: [:index]

  def show
  end

  def index
    if @tag.present?
      @stickies = @tag.stickies.bonzo(params[:bonzo])
    elsif @page.present?
      @stickies = Sticky.newer_than(params[:newer_than])
                        .where(user: @user, page: @page).bonzo(params[:bonzo])
    else
      if current_user.admin?
        @stickies = Sticky.newer_than(params[:newer_than])
                          .where(user: @user).bonzo(params[:bonzo])
      else
        @stickies = Sticky.newer_than(params[:newer_than])
                          .where(user: @user, is_deleted: false).bonzo(params[:bonzo])
      end
    end
    @stickies = [] if @stickies.nil?
  end

  def create
    @sticky = Sticky.new(sticky_params)
    @sticky.user = current_user

    respond_to do |format|
      if @sticky.save
        format.html {
          redirect_to sticky_path(@sticky),
          notice: 'Sticky was successfully created.'
        }
         format.json { render :show, status: :created }
      else
        format.html { render :new }
        format.json { render json: @sticky.errors,
                           status: :unprocessable_entity }
      end
    end
  end


  def new
    @sticky = Sticky.new
    @sticky.user = current_user
  end

  def destroy
    if current_user.admin?
      physical_destroy
    else
      logical_destroy
    end
  end

  def logical_destroy
    @sticky.update is_deleted: true
    respond_to do |format|
      format.html {
        redirect_to stickies_path(@sticky.user),
        notice: 'Sticky was successfully destroyed.'
      }
      format.json { head :no_content }
    end
  end

  def physical_destroy
    @sticky.destroy
    respond_to do |format|
      format.html {
        redirect_to user_stickies_path(@sticky.user),
        notice: 'Sticky was successfully destroyed.'
      }
      format.json { head :no_content }
    end
  end

  def update
    respond_to do |format|
      hash = sticky_params
      hash['tags'] = hash['tags'].map {|t| Tag.find_by(id: t)}.compact
      if @sticky.update(hash)
        format.html {
          redirect_to sticky_path(@sticky),
          notice: 'Sticky was successfully updated.'
        }
        format.json { render :show, status: :ok }
      else
        format.html { render :edit }
        format.json {
          render json: @sticky.errors,
          status: :unprocessable_entity
        }
      end
    end
  end

  private

  def sticky_params
    params.require(:sticky).permit(:content,
                                   :width,
                                   :height,
                                   :left,
                                   :top,
                                   :page_id,
                                   :color,
                                   tags: [])
  end

  def set_sticky
    @sticky  = Sticky.includes(:user).find_by(id: params[:id])
    if @sticky.nil?
      render_not_found
    end
  end

  def set_page
    if params[:page_id]
      @page = Page.find_by(id: params[:page_id])
      render_not_found if @page.nil?
    end
  end

  def set_tag
    if params[:tag_id]
      @tag = Tag.find_by(id: params[:tag_id])
      render_not_found if @tag.nil?
    end
  end

  def set_user
    if params[:user_id]
      @user = User.find_by(id: params[:user_id])
      render_not_found if @user.nil?
      render_forbidden if !current_user.admin? && @user != current_user
    else
      @user = current_user
    end
  end
end
