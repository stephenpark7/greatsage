# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email.to_s }
    password { Faker::Internet.password.to_s }
  end
end
