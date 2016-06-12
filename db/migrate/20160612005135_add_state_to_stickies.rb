class AddStateToStickies < ActiveRecord::Migration
  def change
    add_column :stickies, :state, :integer, :null => false, :default => 0
    add_index :stickies, :state
    Sticky.find_each do |s|
      s.state = s.is_deleted ? Sticky.states[:deleted] : Sticky.states[:normal]
    end
    remove_column :stickies, :is_deleted
  end
end
