class AddAccessTokenToAuthentications < ActiveRecord::Migration
  def change
    add_column :authentications, :access_token,  :string
    add_column :authentications, :access_secret, :string
    add_column :authentications, :credentials,   :string
    add_column :authentications, :name,          :string
    add_column :authentications, :nickname,      :string
    add_column :authentications, :email,         :string
    add_column :authentications, :url,           :string
    add_column :authentications, :image_url,     :string
    add_column :authentications, :description,   :string
  end
end
