class PagesController < ApplicationController
  before_action :require_login
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  def show
  end

  def index
    @pages = Page.where(user: current_user)
  end

  def create
    @page = Page.new(page_params)
    @page.user = current_user

    respond_to do |format|
      if @page.save
        format.html {
          redirect_to page_path(@page),
          notice: 'Page was successfully created.'
        }
         format.json { render :show, status: :created }
      else
        format.html { render :new }
        format.json { render json: @page.errors,
                           status: :unprocessable_entity }
      end
    end
  end

  def new
    @page = Page.new
    @page.user = current_user
  end

  def destory
    @page.destroy
    respond_to do |format|
      format.html {
        redirect_to pages_path(@page.user),
        notice: 'Page was successfully destroyed.'
      }
      format.json { head :no_content }
    end
  end

  def update
    respond_to do |format|
      if @page.update(page_params)
        format.html {
          redirect_to page_path(@page),
          notice: 'Page was successfully updated.'
        }
        format.json { render :show, status: :ok }
      else
        format.html { render :edit }
        format.json {
          render json: @page.errors,
          status: :unprocessable_entity
        }
      end
    end
  end

  private
    def page_params
      params.require(:page).permit(:title,
                                   :url)
    end

    def set_page
      @page  = Page.includes(:user).find_by(id: params[:id])
      if @page.nil?
        render_not_found
      end
    end
end
