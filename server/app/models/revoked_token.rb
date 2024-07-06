# frozen_string_literal: true

class RevokedToken < ApplicationRecord
  belongs_to :user
end
