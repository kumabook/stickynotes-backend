class Sticky < ActiveRecord::Base
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
end
