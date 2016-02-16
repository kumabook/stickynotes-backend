class Sticky < ActiveRecord::Base
  belongs_to :user
  belongs_to :page
  has_many :sticky_tags
  has_many :tags, through: :sticky_tags
  paginates_per 20

  scope :newer_than, -> since {
    where('updated_at >= ?', Time.parse(since)) if since.present?
  }
end
