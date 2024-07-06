# frozen_string_literal: true

require_relative 'boot'

require 'dotenv'
require 'rails/all'

Dotenv.load('.env') if Rails.env.development? || Rails.env.test?

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ProductivityAppServer
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
    config.i18n.available_locales = [:en]
    config.i18n.default_locale = :en

    config.time_zone = 'Central Time (US & Canada)'
    # config.eager_load_paths << Rails.root.join("extras")
    config.autoload_paths << Rails.root.join('lib')

    config.logger = Logger.new("log/#{Rails.env}.log")
  end
end
