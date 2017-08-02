task :send_introduce_new_ios_app => :environment do
  UserMailer.introduce_new_ios_app.deliver
end
