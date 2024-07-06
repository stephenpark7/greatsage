# frozen_string_literal: true

class User < ApplicationRecord
  include Exceptions

  has_secure_password
  has_secure_password :recovery_password, validations: false

  validates :email, presence: true, uniqueness: true, email: { mode: :strict, require_fqdn: true }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  has_many :access_tokens, dependent: :destroy
  has_many :refresh_tokens, dependent: :destroy
  has_many :revoked_tokens, dependent: :destroy

  has_many :todo_lists, dependent: :destroy

  def self.create!(**args)
    super(args)
  rescue ActiveRecord::RecordInvalid => e
    raise ValidationError, e.record.errors.messages
  end
end
