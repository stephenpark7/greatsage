# frozen_string_literal: true

class CreateRevokedTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :revoked_tokens do |t|
      t.string :jti, null: false
      t.references :user, foreign_key: true
      t.datetime :expires_at, null: false

      t.timestamps
    end

    add_index :revoked_tokens, :jti, unique: true
  end
end
