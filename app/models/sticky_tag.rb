class StickyTag < ActiveRecord::Base
  belongs_to :sticky
  belongs_to :tag
end
