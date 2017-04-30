require 'rest_client'

class Page < ApplicationRecord
  belongs_to :user
  has_many :stickies

  def fetch_visual_url
    params   = { url: url };
    response = RestClient.get("http://opengrapher.herokuapp.com/opengraph",
                              params: params,
                              accept: :json)
    opengraph_obj = JSON.parse(response)
    images =  opengraph_obj["images"]
    if !images.nil? && images.count > 0
      return images[0]["url"]
    end
    nil
  end

  def update_visual_url
    self.visual_url = fetch_visual_url
    self.save
  end

  def self.update_visuals
    p Page.where(visual_url: nil).count
    Page.where(visual_url: nil).find_each do |page|
      begin
        page.update_visual_url
      rescue
      end
    end
  end
end
