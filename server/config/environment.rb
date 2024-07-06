# frozen_string_literal: true

# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

Rails.logger = Logger.new($stdout)
Rails.logger.level = Logger::INFO
Rails.logger.datetime_format = '%Y-%m-%d %H:%M:%S'
