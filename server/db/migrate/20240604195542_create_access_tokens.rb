# frozen_string_literal: true

class CreateAccessTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :access_tokens do |t|
      t.string :jti, null: false
      t.references :user, foreign_key: true
      t.datetime :expires_at, null: false

      t.timestamps
    end

    add_index :access_tokens, :jti, unique: true
  end
end
