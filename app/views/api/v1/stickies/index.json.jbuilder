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
                :is_deleted,
                :updated_at, :created_at
  json.url sticky.page.url
  json.title sticky.page.title
  json.tags sticky.tags.map {|t| t.name}
end

