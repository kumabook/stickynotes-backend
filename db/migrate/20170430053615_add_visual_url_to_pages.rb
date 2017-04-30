class AddVisualUrlToPages < ActiveRecord::Migration[5.0]
  def change
    add_column :pages, :visual_url, :string
  end
end
