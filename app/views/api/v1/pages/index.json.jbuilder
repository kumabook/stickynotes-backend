json.array!(@pages) do |page|
  json.extract! page,
                :id,
                :url,
                :visual_url,
                :title,
                :user_id,
                :updated_at,
                :created_at
end
