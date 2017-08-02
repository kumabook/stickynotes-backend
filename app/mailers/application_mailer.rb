class ApplicationMailer < ActionMailer::Base
  default from: StickynotesBackend::Application.config.sender_email
  layout 'mailer'
end
