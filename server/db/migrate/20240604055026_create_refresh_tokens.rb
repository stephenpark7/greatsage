# frozen_string_literal: true

class CreateRefreshTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :refresh_tokens do |t|
      t.string :jti, null: false
      t.references :user, foreign_key: true
      t.datetime :expires_at, null: false

      t.timestamps
    end

    add_index :refresh_tokens, :jti, unique: true
  end
end
