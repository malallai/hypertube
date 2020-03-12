require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Hypertube
  class Application < Rails::Application
    # Expose our application's helpers to Administrate
    config.to_prepare do
      Administrate::ApplicationController.helper Hypertube::Application.helpers
    end
    config.active_job.queue_adapter = :sidekiq
    config.application_name = Rails.application.class.module_parent_name
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    Tmdb::Api.key(ENV['THEMOVIEDB_KEY'])

    $qbt_client = QbtClient::WebUI.new(ENV['QBIT_HOST'], ENV['QBIT_PORT'], ENV['QBIT_USER'], ENV['QBIT_PASS'])
    $qbt_client.set_preferences({
                                    max_active_downloads: 500,
                                    max_active_torrents: 500,
                                    max_active_uploads: 500,
                                    web_ui_session_timeout: 0
                                })

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
