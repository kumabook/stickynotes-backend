json.array!(@stickies) do |sticky|
  json.extract! sticky,
                :id,
                :uuid,
                :content,
                :color,
                :width, :height,
                :left, :top,
                :page,
                :tags,
                :user_id,
                :updated_at, :created_at
  json.state      Sticky.states[sticky.state]
  json.is_deleted sticky.deleted?
  json.url        sticky.page.url
  json.title      sticky.page.title
  json.visual_url sticky.page.visual_url
  json.tags       sticky.tags.map {|t| t.name}
end

