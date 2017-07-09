# coding: utf-8

task :update_visuals => :environment do
  Page.where(visual_url: nil)
    .where(created_at: 2.hours.ago..Time.now)
    .order('created_at DESC').each do |page|
    begin
      page.update_visual_url
    rescue
    end
  end
end
