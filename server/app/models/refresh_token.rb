# frozen_string_literal: true

class RefreshToken < ApplicationRecord
  belongs_to :user

  CREATE_INSTANCE = true
  EXPIRY_TIME = 7 * 24 * 60 * 60
end
