class CreateStickyTags < ActiveRecord::Migration
  def change
    create_table :sticky_tags do |t|
      t.uuid :sticky_id
      t.integer :tag_id

      t.timestamps null: false
    end
  end
end
