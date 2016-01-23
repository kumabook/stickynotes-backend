class StickiesController < ApplicationController
  before_action :require_login
  before_action :set_sticky, only: [:show, :edit, :update, :destroy]
  before_action :set_page

  def show
  end

  def index
    if @page.nil?
      @stickies = Sticky.newer_than(params[:newer_than])
                        .where(user: current_user)
    else
      @stickies = Sticky.newer_than(params[:newer_than])
                        .where(page: @page.id)
    end
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
    @sticky.destroy
    respond_to do |format|
      format.html {
        redirect_to stickies_path(@sticky.user),
        notice: 'Sticky was successfully destroyed.'
      }
      format.json { head :no_content }
    end
  end

  def update
    respond_to do |format|
      if @sticky.update(sticky_params)
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
                                   :page_id)
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
end
