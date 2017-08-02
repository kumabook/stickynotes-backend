class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password_email.subject
  #
  def reset_password_email(user)
    @user = User.find user.id
    @url  = edit_password_reset_url(@user.reset_password_token)
    mail(to:      user.email,
         subject: "Your password has been reset")
  end

  def introduce_new_ios_app
    subject = 'Introducing new StickyNotes iOS App'
    mail(to:      StickynotesBackend::Application.config.sender_email,
         bcc:     User.all.map {|user| user.email },
         subject: subject)
  end
end
