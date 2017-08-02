task :send_introduce_new_ios_app => :environment do
  User.all.each do |user|
    begin
      UserMailer.introduce_new_ios_app(user).deliver
    rescue
      puts "#{user.email} seems to be invalid"
    end
  end
end
