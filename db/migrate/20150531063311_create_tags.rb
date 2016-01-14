class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string  :name,    :null => false
      t.integer :user_id, :null => false

      t.timestamps null: false
    end
    add_index :tags, [:name, :user_id], :unique => true,
                                          :name => 'by_name_each_user'
  end
end
