class Api::V1::StickiesController < Api::V1::ApiController
  before_action :doorkeeper_authorize!
  after_action :touch_user, only: [:import]
  respond_to    :json

  def index
    con = ActiveRecord::Base.connection
    sticky_sql = Sticky.newer_than(params[:newer_than])
                       .where(user: current_resource_owner).to_sql
    items = con.select_all(sticky_sql).to_hash
    page_sql = Page.where(id: items.map {|i| i["page_id"] }).to_sql
    pages = con.select_all(page_sql).to_hash
    tag_sql = Tag.eager_load(:sticky_tags)
                 .where(sticky_tags: { sticky_id: items.map {|i| i["id"] }}).to_sql
    tags = con.select_all(tag_sql).to_hash.map do |h|
      {
        "id"         => h["t0_r0"],
        "name"       => h["t0_r1"],
        "user_id"    => h["t0_r2"],
        "created_at" => h["t0_r3"],
        "updated_at" => h["t0_r4"],
        "sticky_id"  => h["t1_r1"],
      }
    end
    stickies = Sticky.normalize_items(items, pages, tags)
    logger.info("User(id=#{current_resource_owner.id}) fetches #{stickies.size} stickies.")
    respond_to do |format|
      format.html
      format.json { render json: stickies }
    end
  end

  def import
    stickies = stickies_params["stickies"].present? ? stickies_params["stickies"] : []
    logger.info("User(id=#{current_resource_owner.id}) imports #{stickies.size} stickies.")
    deleted = Sticky.states[:deleted]
    normal  = Sticky.states[:normal]
    @stickies = stickies.map do |s|
      user = current_resource_owner
      page = Page.find_or_create_by url:     s['url'],
                                    user_id: user.id do |p|
        p.title = s['title']
      end
      sticky = Sticky.find_or_initialize_by(uuid: s['uuid'], user_id: user.id) do |v|
        v.page_id = page.id
      end
      state = s['state']
      if state.nil?
        state = s['is_deleted'] ? deleted : normal
      end
      sticky.update_attributes page_id: page.id,
                               user_id: user.id,
                               color:   s['color'],
                               content: s['content'],
                               width:   s['width'],
                               height:  s['height'],
                               left:    s['left'],
                               top:     s['top'],
                               state:   state
      s['tags'] && s['tags'].each do |name|
        tag = Tag.find_or_create_by name: name,
                                    user_id: user.id
        StickyTag.find_or_create_by(sticky_id: sticky.id,
                                    tag_id:    tag.id)
      end
      sticky
    end
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
    params.permit(:format,
                  stickies: [:id,
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
                             :state,
                             :is_deleted,
                             tags: []])
  end

  def touch_user
    current_resource_owner.touch
  end
end
