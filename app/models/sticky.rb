class Sticky < ApplicationRecord
  enum state: { normal: 0, deleted: 1, minimized: 2 }
  belongs_to :user
  belongs_to :page
  has_many :sticky_tags
  has_many :tags, through: :sticky_tags
  paginates_per 20
  default_scope ->{ order('updated_at DESC') }

  scope :newer_than, -> since {
    where('updated_at >= ?', Time.parse(since)) if since.present?
  }

  def as_json(options = {})
    h               = super(options)
    h["state"]      = Sticky.states[state]
    h["is_deleted"] = deleted?
    h["url"]        = page.url
    h["title"]      = page.title
    h["visual_url"] = page.visual_url
    h["page"]       = page
    h["tags"]       = tags.map {|t| t.name}
    h["created_at"] = Time.parse(h["created_at"]).iso8601
    h["updated_at"] = Time.parse(h["updated_at"]).iso8601
    h.delete("page_id")
    h
  end

  def self.normalize_items(items, pages, tags)
    items.map do |h|
      page            = pages.select {|v| v["id"] == h["page_id"] }.first
      tag_names       = tags.select {|v| v["sticky_id"] == h["id"] }.map {|v| v["name"] }
      h["state"]      = h["state"]
      h["is_deleted"] = h["state"] == "deleted"
      h["url"]        = page["url"]
      h["title"]      = page["title"]
      h["visual_url"] = page["visual_url"]
      h["page"]       = page
      h["tags"]       = tag_names
      h.delete("page_id")
      h
    end
  end
end
