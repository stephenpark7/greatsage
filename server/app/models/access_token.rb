# frozen_string_literal: true

class AccessToken < ApplicationRecord
  belongs_to :user

  CREATE_INSTANCE = false
  EXPIRY_TIME = 15 * 60
end
