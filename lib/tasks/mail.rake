task :send_introduce_new_ios_app => :environment do
  User.all.each do |user|
    begin
      if user.email_subscription_enabled?
        UserMailer.introduce_new_ios_app(user).deliver
      end
    rescue
      puts "#{user.email} seems to be invalid"
    end
  end
end
