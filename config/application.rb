require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module StickynotesBackend
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.sender_email = "stickynotes@outlook.jp"
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins ENV['ACCESS_CONTROL_ALLOW_ORIGIN'] || '*'
        resource '*', :headers => :any, :methods => [:get, :post, :put, :options]
      end
    end
  end
end
