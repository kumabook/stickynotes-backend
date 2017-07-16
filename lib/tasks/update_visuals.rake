# coding: utf-8

task :update_visuals => :environment do
  puts "Start update_visuals task..."
  Page.where(visual_url: nil)
    .where(created_at: 2.hours.ago..Time.now)
    .order('created_at DESC').each do |page|
    begin
      page.update_visual_url
    rescue
    end
  end
  puts "Complete update_visuals task..."
end
