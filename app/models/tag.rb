class Tag < ActiveRecord::Base
  belongs_to :user
  has_many :sticky_tags
  has_many :stickies, through: :sticky_tags
end
