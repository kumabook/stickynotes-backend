class StickyTag < ApplicationRecord
  belongs_to :sticky, touch: true
  belongs_to :tag,    touch: true
end
