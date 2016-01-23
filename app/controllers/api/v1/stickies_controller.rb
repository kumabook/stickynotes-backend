class Api::V1::StickiesController < Api::V1::ApiController
  before_action :doorkeeper_authorize!
  respond_to    :json

  def index
    if @page.nil?
      @stickies = Sticky.newer_than(params[:newer_than])
                        .where(user: current_resource_owner)
    else
      @stickies = Sticky.newer_than(params[:newer_than])
                        .where(page: @page.id)
    end
    respond_to do |format|
      format.html
      format.json { render :index, status: 200 }
    end
  end

  def import
    stickies = stickies_params["stickies"].present? ? stickies_params["stickies"] : []
    @stickies = stickies.map {|s|
      user = current_resource_owner
      page = Page.find_or_create_by url: s['url'],
                                    title: s['title'],
                                    user_id: user.id
      sticky = Sticky.find_or_create_by uuid: s['uuid'],
                                        page_id: page.id,
                                        user_id: user.id
      sticky.update_attributes page_id: page.id,
                               user_id: user.id,
                               color: s['color'],
                               content: s['content'],
                               width: s['width'],
                               height: s['height'],
                               left: s['left'],
                               top: s['top'],
                               is_deleted: s['is_deleted']
      sticky
    }
    respond_to do |format|
      if @stickies.map {|s| s.save }.all?
        format.json { render json: @stickies.to_json,
                           status: :created }
      else
        format.json { render json: @stickies.to_json,
                           status: :unprocessable_entity }
      end
    end
  end

  private
  def stickies_params
    params.permit(stickies: [:id,
                             :uuid,
                             :content,
                             :width,
                             :height,
                             :left,
                             :top,
                             :url,
                             :title,
                             :color,
                             :created_at,
                             :updated_at,
                             :user_id,
                             :is_deleted,
                             :tags])
  end
end
