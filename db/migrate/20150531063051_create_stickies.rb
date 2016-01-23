class CreateStickies < ActiveRecord::Migration
  def change
    create_table :stickies do |t|
      t.uuid    :uuid,       :null => false, :default => 'uuid_generate_v4()'
      t.integer :width,      :null => false, :default => 0
      t.integer :height,     :null => false, :default => 0
      t.integer :left,       :null => false, :default => 0
      t.integer :top,        :null => false, :default => 0
      t.text    :content,    :null => false, :default => ""
      t.string  :color,      :null => false, :default => "blue"
      t.integer :page_id,    :null => false
      t.integer :user_id,    :null => false
      t.boolean :is_deleted, :null => false, :default => false

      t.timestamps null: false
      t.index [:user_id, :uuid], :unique => true
    end
  end
end
