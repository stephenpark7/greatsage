# frozen_string_literal: true

REDIS_OPTIONS = {
  url: ENV['REDIS_URL'],
  ssl_params: {
    verify_mode: Rails.env.production? ? OpenSSL::SSL::VERIFY_PEER : OpenSSL::SSL::VERIFY_NONE
  }
}.freeze

Sidekiq.configure_server do |config|
  config.redis = REDIS_OPTIONS
end

Sidekiq.configure_client do |config|
  config.redis = REDIS_OPTIONS
end
