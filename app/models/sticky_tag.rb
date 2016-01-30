class StickyTag < ActiveRecord::Base
  belongs_to :sticky, touch: true
  belongs_to :tag,    touch: true
end
