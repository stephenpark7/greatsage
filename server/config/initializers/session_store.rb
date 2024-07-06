# frozen_string_literal: true

Rails.application.config.session_store :cookie_store,
                                       key: ENV['SECRET_KEY_BASE'],
                                       secure: Rails.env.production?,
                                       same_site: :strict,
                                       http_only: true
