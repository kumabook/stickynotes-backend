class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string  :title,   :null => false, :default => ""
      t.string  :url,     :null => false
      t.integer :user_id, :null => false

      t.timestamps null: false
    end
    add_index :pages, [:url, :user_id], :unique => true,
                                          :name => 'by_url_each_user'
  end
end
