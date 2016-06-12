json.array!(@stickies) do |sticky|
  json.extract! sticky,
                :id,
                :content,
                :color,
                :width, :height,
                :left, :top,
                :page,
                :user_id,
                :state,
                :updated_at, :created_at
  json.is_deleted sticky.deleted?
  json.url sticky.page.url
  json.title sticky.page.title
  json.tags sticky.tags.map {|t| t.name}
end
