require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NPS
  class Application < Rails::Application
    require 'configatron'
    Configatron::Integrations::Rails.init

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.active_job.queue_adapter = :sidekiq

    config.session_store :cookie_store, key: '_NPS_session'
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use config.session_store, config.session_options

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: configatron.smtp.address,
      port: configatron.smtp.port,
      domain: configatron.smtp.domain,
      user_name: configatron.smtp.user_name,
      password: configatron.smtp.password,
      authentication: "plain"
    }
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = true
  end
end
